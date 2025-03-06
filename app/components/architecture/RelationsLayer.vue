<template>
  <svg class="absolute top-0 left-0" :style="{ width: '5000px', height: '5000px', pointerEvents: 'none', zIndex: 100 }">
    <g v-for="relation in relations" :key="relation.id">
      <path
        :d="calculateRelationPath(relation)"
        :stroke="getRelationColor(relation)"
        stroke-width="2"
        fill="none"
        style="pointer-events: all; cursor: pointer"
        @click="$emit('remove-relation', relation.id)"
      />
    </g>
  </svg>
</template>

<script setup>
import { defineProps, defineEmits } from 'vue'

const props = defineProps({
  relations: {
    type: Array,
    required: true
  },
  components: {
    type: Array,
    required: true
  }
})

defineEmits(['remove-relation'])

const getRelationColor = (relation) => {
  const fromComponent = props.components.find(c => c.id === relation.fromComponent)
  if (!fromComponent?.color) return '#666'
  
  // Convert hex to RGB
  const hex = fromComponent.color.replace('#', '')
  const r = parseInt(hex.substring(0, 2), 16)
  const g = parseInt(hex.substring(2, 4), 16)
  const b = parseInt(hex.substring(4, 6), 16)
  
  // Make color darker by reducing RGB values
  const darkerR = Math.max(0, r - 40)
  const darkerG = Math.max(0, g - 40)
  const darkerB = Math.max(0, b - 40)
  
  return `rgb(${darkerR}, ${darkerG}, ${darkerB})`
}

const calculateRelationPath = (relation) => {
  const fromComponent = props.components.find(c => c.id === relation.fromComponent)
  const toComponent = props.components.find(c => c.id === relation.toComponent)
  
  if (!fromComponent || !toComponent) return ''

  // Find the output point position
  const output = fromComponent.outputs.find(o => o.id === relation.outputId)
  const outputIndex = fromComponent.outputs.indexOf(output)
  const startY = fromComponent.y + 96 + (outputIndex * 16)
  const startX = fromComponent.x + 300 - 15 // Start from the blue dot

  // Find the input point position
  const input = toComponent.inputs.find(i => i.id === relation.inputId)
  const inputIndex = toComponent.inputs.indexOf(input)
  const endY = toComponent.y + 96 + (inputIndex * 16)
  const endX = toComponent.x + 15 // End at the green dot

  const midX = (startX + endX) / 2

  return `M ${startX} ${startY} L ${midX} ${startY} L ${midX} ${endY} L ${endX} ${endY}`
}
</script> 