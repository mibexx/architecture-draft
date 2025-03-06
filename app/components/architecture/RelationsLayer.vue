<template>
  <svg class="absolute top-0 left-0" :style="{ width: '5000px', height: '5000px', pointerEvents: 'none', zIndex: 100 }">
    <g v-for="relation in relations" :key="relation.id">
      <path
        :d="calculateRelationPath(relation)"
        :stroke="getRelationColor(relation)"
        stroke-width="2"
        fill="none"
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

const getRelationColor = (relation) => {
  const fromComponent = props.components.find(c => c.id === relation.fromComponent)
  if (!fromComponent?.color) return '#666'
  
  // Convert hex to RGB
  const hex = fromComponent.color.replace('#', '')
  const r = parseInt(hex.substring(0, 2), 16)
  const g = parseInt(hex.substring(2, 4), 16)
  const b = parseInt(hex.substring(4, 6), 16)
  
  // Make color darker by reducing RGB values
  const darkerR = Math.max(0, r - 20)
  const darkerG = Math.max(0, g - 20)
  const darkerB = Math.max(0, b - 20)
  
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
  const startX = fromComponent.x + 300 - 15

  // Find the input point position
  const input = toComponent.inputs.find(i => i.id === relation.inputId)
  const inputIndex = toComponent.inputs.indexOf(input)
  const endY = toComponent.y + 96 + (inputIndex * 16)
  const endX = toComponent.x + 15

  // Prüfe, ob die Verbindung von rechts nach links geht
  const isRightToLeft = startX > endX

  // Berechne die Basis-Mittellinie
  const baseMidX = (startX + endX) / 2
  
  // Finde alle Verbindungen zwischen denselben Komponenten
  const parallelConnections = props.relations.filter(r => 
    (r.fromComponent === relation.fromComponent && r.toComponent === relation.toComponent) ||
    (r.fromComponent === relation.toComponent && r.toComponent === relation.fromComponent)
  )
  
  // Bestimme den Index dieser Verbindung in der Gruppe paralleler Verbindungen
  const connectionIndex = parallelConnections.indexOf(relation)
  
  // Berechne den horizontalen Offset basierend auf dem Index
  const offset = (connectionIndex - (parallelConnections.length - 1) / 2) * 20
  const midX = baseMidX + offset

  if (isRightToLeft) {
    // Finde die maximale Y-Position aller Komponenten plus Puffer
    const maxComponentY = Math.max(...props.components.map(c => c.y + 200))
    // Berechne Y-Offset für parallele Linien
    const yOffset = connectionIndex * 20
    const bottomY = maxComponentY + yOffset

    return `M ${startX} ${startY} 
            L ${startX + 20} ${startY} 
            L ${startX + 20} ${bottomY} 
            L ${endX - 20} ${bottomY} 
            L ${endX - 20} ${endY} 
            L ${endX} ${endY}`
  }

  return `M ${startX} ${startY} L ${midX} ${startY} L ${midX} ${endY} L ${endX} ${endY}`
}
</script> 