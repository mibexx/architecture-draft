<template>
  <div 
    class="absolute p-4 rounded-lg shadow cursor-move flex flex-col"
    :style="{ 
      left: component.x + 'px', 
      top: component.y + 'px', 
      width: '300px', 
      position: 'absolute', 
      zIndex: 20,
      backgroundColor: component.color || '#f3f4f6',
      minHeight: '120px',
      zIndex: 50
    }"
    @mousedown="startDrag"
    :data-component-id="component.id"
  >
    <!-- Main content -->
    <div class="flex-1">
      <ComponentHeader 
        :component="component"
        @delete="$emit('delete', component.id)"
        @color-pick="$emit('color-pick', component)"
      />
      
      <InputOutputSection 
        :component="component"
        @add-input="$emit('add-input', component)"
        @add-output="$emit('add-output', component)"
        @remove-input="$emit('remove-input', component, $event)"
        @remove-output="$emit('remove-output', component, $event)"
        @input-click="$emit('input-click', component, $event)"
        @output-click="$emit('output-click', component, $event)"
      />
    </div>

    <!-- Footer with controls -->
    <div class="flex justify-between items-center mt-4 export-hide">
      <!-- Color picker button -->
      <button
        :class="getTextColor('text-gray-500 hover:text-gray-700')"
        class="hover:text-gray-600"
        @click.stop="$emit('color-pick', component)"
        @mousedown.stop
      >
        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
          <path fill-rule="evenodd" d="M4 2a2 2 0 00-2 2v11a3 3 0 106 0V4a2 2 0 00-2-2H4zm1 14a1 1 0 100-2 1 1 0 000 2zm5-1.757l4.9-4.9a2 2 0 000-2.828L13.485 5.1a2 2 0 00-2.828 0L5.757 10l4.9 4.243zm-5-9.243a1 1 0 100-2 1 1 0 000 2z" clip-rule="evenodd" />
        </svg>
      </button>

      <!-- Drag handle -->
      <div class="cursor-move">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" :class="getTextColor('text-gray-500 hover:text-gray-700')" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 9h8m-8 4h8m-8 4h8" />
        </svg>
      </div>

      <!-- Delete button -->
      <button
        :class="getTextColor('text-gray-500 hover:text-gray-700')"
        class="hover:text-red-600"
        @click.stop="$emit('delete', component.id)"
        @mousedown.stop
      >
        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
          <path fill-rule="evenodd" d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z" clip-rule="evenodd" />
        </svg>
      </button>
    </div>
  </div>
</template>

<script setup>
import { defineProps, defineEmits } from 'vue'
import ComponentHeader from './ComponentHeader.vue'
import InputOutputSection from './InputOutputSection.vue'

const props = defineProps({
  component: {
    type: Object,
    required: true
  }
})

const emit = defineEmits([
  'delete',
  'color-pick',
  'add-input',
  'add-output',
  'remove-input',
  'remove-output',
  'input-click',
  'output-click',
  'drag-start'
])

const startDrag = (event) => {
  if (event.target.tagName.toLowerCase() === 'input') {
    return
  }
  emit('drag-start', event, props.component)
}

const getTextColor = (baseClasses) => {
  if (!props.component.color) return baseClasses + ' text-gray-800'
  
  // Convert hex to RGB
  const hex = props.component.color.replace('#', '')
  const r = parseInt(hex.substring(0, 2), 16)
  const g = parseInt(hex.substring(2, 4), 16)
  const b = parseInt(hex.substring(4, 6), 16)
  
  // Calculate relative luminance
  const luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255
  
  return baseClasses + (luminance > 0.6 ? ' text-gray-800' : ' text-white')
}

const startEditingName = () => {
  props.component.editingName = true
  nextTick(() => {
    nameInput.value?.focus()
  })
}
</script> 