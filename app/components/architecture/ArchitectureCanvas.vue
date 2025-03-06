<template>
  <div class="container mx-auto px-4">
    <CanvasHeader @zoom="handleZoom" @add-component="addComponent" @export-png="exportToPNG" @export-pdf="exportToPDF" />

    <!-- Canvas for system architecture -->
    <div 
      id="architecture-canvas"
      class="bg-white p-6 rounded-lg shadow-lg min-h-[700px] relative overflow-hidden" 
      ref="canvas"
      @mousedown="startPan"
      @wheel.prevent="handleZoom"
      @mousemove="onCanvasMouseMove"
      @mouseup="onCanvasMouseUp"
    >
      <!-- Zoomable/Pannable Container -->
      <div 
        class="absolute"
        :style="{
          transform: `scale(${scale}) translate(${panX}px, ${panY}px)`,
          transformOrigin: '0 0'
        }"
      >
        <!-- Relations Layer -->
        <RelationsLayer 
          :relations="relations"
          :components="components"
          @remove-relation="removeRelation"
        />

        <!-- Components -->
        <ComponentNode
          v-for="component in components"
          :key="component.id"
          :component="component"
          @delete="deleteComponent"
          @color-pick="openColorPicker"
          @add-input="addInput"
          @add-output="addOutput"
          @remove-input="removeInput"
          @remove-output="removeOutput"
          @input-click="handleInputClick"
          @output-click="handleOutputClick"
          @drag-start="startDrag"
        />
      </div>
    </div>

    <!-- Color Picker Dialog -->
    <ColorPickerDialog
      :show="showColorPicker"
      :selected-color="selectedComponent?.color"
      @close="closeColorPicker"
      @select-color="setComponentColor"
    />
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import html2canvas from 'html2canvas'
import jsPDF from 'jspdf'
import ComponentNode from './ComponentNode.vue'
import RelationsLayer from './RelationsLayer.vue'
import ColorPickerDialog from './ColorPickerDialog.vue'
import CanvasHeader from './CanvasHeader.vue'

const components = ref([])
const canvas = ref(null)
let draggedComponent = null
let initialMousePosition = { x: 0, y: 0 }
let initialComponentPosition = { x: 0, y: 0 }

// Pan and zoom state
const scale = ref(1)
const panX = ref(0)
const panY = ref(0)
let isPanning = false
let lastPanPosition = { x: 0, y: 0 }

// Relations state
const relations = ref([])
const selectedOutputId = ref(null)
const selectedOutputComponent = ref(null)

// Color picker state
const showColorPicker = ref(false)
const selectedComponent = ref(null)

const zoom = (delta) => {
  const newScale = scale.value + delta
  if (newScale >= 0.1 && newScale <= 3) {
    scale.value = newScale
  }
}

const handleZoom = (event) => {
  if (typeof event === 'number') {
    // Button click
    zoom(event)
  } else {
    // Mouse wheel
    const delta = -event.deltaY * 0.001
    zoom(delta)
  }
}

const startPan = (event) => {
  if (event.target === canvas.value) {
    isPanning = true
    lastPanPosition = {
      x: event.clientX,
      y: event.clientY
    }
  }
}

const onCanvasMouseMove = (event) => {
  if (isPanning) {
    const dx = event.clientX - lastPanPosition.x
    const dy = event.clientY - lastPanPosition.y
    panX.value += dx / scale.value
    panY.value += dy / scale.value
    lastPanPosition = {
      x: event.clientX,
      y: event.clientY
    }
  }
}

const onCanvasMouseUp = () => {
  isPanning = false
}

const findNonCollidingPosition = (newComponent) => {
  const componentWidth = 300
  const componentHeight = 150
  const padding = 20
  let x = 100
  let y = 100
  let collision = true
  
  while (collision) {
    collision = components.value.some(component => {
      if (component.id === newComponent.id) return false
      return Math.abs(component.x - x) < (componentWidth + padding) &&
             Math.abs(component.y - y) < (componentHeight + padding)
    })
    
    if (collision) {
      x += componentWidth + padding
      if (x > canvas.value?.clientWidth - componentWidth) {
        x = 100
        y += componentHeight + padding
      }
    }
  }
  
  return { x, y }
}

const generateUniqueId = () => {
  return Math.random().toString(36).substr(2, 9)
}

const addComponent = () => {
  const newComponent = {
    id: generateUniqueId(),
    name: 'New Component',
    type: 'Service',
    x: 0,
    y: 0,
    inputs: [],
    outputs: [],
    color: '#f3f4f6',
    editingName: false,
    editingType: false
  }
  
  const position = findNonCollidingPosition(newComponent)
  newComponent.x = position.x
  newComponent.y = position.y
  
  components.value.push(newComponent)
}

const deleteComponent = (componentId) => {
  components.value = components.value.filter(c => c.id !== componentId)
  relations.value = relations.value.filter(r => 
    r.fromComponent !== componentId && r.toComponent !== componentId
  )
}

const addInput = (component) => {
  component.inputs.push({
    id: generateUniqueId(),
    name: '',
    editing: false
  })
}

const addOutput = (component) => {
  component.outputs.push({
    id: generateUniqueId(),
    name: '',
    editing: false
  })
}

const removeInput = (component, inputId) => {
  component.inputs = component.inputs.filter(input => input.id !== inputId)
  relations.value = relations.value.filter(relation => relation.inputId !== inputId)
}

const removeOutput = (component, outputId) => {
  component.outputs = component.outputs.filter(output => output.id !== outputId)
  relations.value = relations.value.filter(relation => relation.outputId !== outputId)
  if (selectedOutputId.value === outputId) {
    selectedOutputId.value = null
    selectedOutputComponent.value = null
  }
}

const removeRelation = (relationId) => {
  relations.value = relations.value.filter(relation => relation.id !== relationId)
}

const handleOutputClick = (component, output) => {
  if (selectedOutputId.value === output.id) {
    selectedOutputId.value = null
    selectedOutputComponent.value = null
  } else {
    selectedOutputId.value = output.id
    selectedOutputComponent.value = component
  }
}

const handleInputClick = (inputComponent, input) => {
  if (selectedOutputId.value && selectedOutputComponent.value) {
    // Don't allow connecting to self
    if (selectedOutputComponent.value.id === inputComponent.id) {
      return
    }
    
    // Check if relation already exists
    const exists = relations.value.some(r => 
      r.outputId === selectedOutputId.value && r.inputId === input.id
    )
    
    if (!exists) {
      relations.value.push({
        id: generateUniqueId(),
        outputId: selectedOutputId.value,
        inputId: input.id,
        fromComponent: selectedOutputComponent.value.id,
        toComponent: inputComponent.id
      })
    }
    
    selectedOutputId.value = null
    selectedOutputComponent.value = null
  }
}

const startDrag = (event, component) => {
  draggedComponent = component
  initialMousePosition = {
    x: event.clientX,
    y: event.clientY
  }
  initialComponentPosition = {
    x: component.x,
    y: component.y
  }
  
  document.addEventListener('mousemove', onDrag)
  document.addEventListener('mouseup', stopDrag)
}

const onDrag = (event) => {
  if (draggedComponent) {
    const dx = (event.clientX - initialMousePosition.x) / scale.value
    const dy = (event.clientY - initialMousePosition.y) / scale.value
    
    draggedComponent.x = initialComponentPosition.x + dx
    draggedComponent.y = initialComponentPosition.y + dy
  }
}

const stopDrag = () => {
  draggedComponent = null
  document.removeEventListener('mousemove', onDrag)
  document.removeEventListener('mouseup', stopDrag)
}

const openColorPicker = (component) => {
  selectedComponent.value = component
  showColorPicker.value = true
}

const closeColorPicker = () => {
  showColorPicker.value = false
  selectedComponent.value = null
}

const setComponentColor = (color) => {
  if (selectedComponent.value) {
    selectedComponent.value.color = color
  }
}

const exportToPNG = async () => {
  // Hide export-related elements
  const elementsToHide = document.querySelectorAll('.export-hide')
  elementsToHide.forEach(el => el.style.display = 'none')

  try {
    const canvasElement = document.getElementById('architecture-canvas')
    const canvas = await html2canvas(canvasElement, {
      scale: 2,
      backgroundColor: '#ffffff'
    })
    
    const link = document.createElement('a')
    link.download = 'system-architecture.png'
    link.href = canvas.toDataURL('image/png')
    link.click()
  } finally {
    elementsToHide.forEach(el => el.style.display = '')
  }
}

const exportToPDF = async () => {
  // Hide export-related elements
  const elementsToHide = document.querySelectorAll('.export-hide')
  elementsToHide.forEach(el => el.style.display = 'none')

  try {
    const canvasElement = document.getElementById('architecture-canvas')
    const canvas = await html2canvas(canvasElement, {
      scale: 2,
      backgroundColor: '#ffffff'
    })
    
    const imgData = canvas.toDataURL('image/png')
    const pdf = new jsPDF({
      orientation: 'landscape',
      unit: 'px',
      format: [canvas.width, canvas.height]
    })
    
    pdf.addImage(imgData, 'PNG', 0, 0, canvas.width, canvas.height)
    pdf.save('system-architecture.pdf')
  } finally {
    elementsToHide.forEach(el => el.style.display = '')
  }
}

onUnmounted(() => {
  document.removeEventListener('mousemove', onDrag)
  document.removeEventListener('mouseup', stopDrag)
})
</script> 