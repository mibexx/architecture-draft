<template>
  <div 
    class="absolute p-4 rounded-lg shadow cursor-move"
    :style="{ 
      left: component.x + 'px', 
      top: component.y + 'px', 
      width: '300px', 
      position: 'absolute', 
      zIndex: 20,
      backgroundColor: component.color || '#f3f4f6',
      paddingBottom: '2rem'
    }"
    @mousedown="startDrag"
    :data-component-id="component.id"
  >
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

    <!-- Drag handle -->
    <div class="absolute bottom-2 left-1/2 transform -translate-x-1/2 cursor-move export-hide">
      <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 9h8m-8 4h8m-8 4h8" />
      </svg>
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
</script> 