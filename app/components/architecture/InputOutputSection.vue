<template>
  <div class="flex mb-4">
    <!-- Inputs on left -->
    <div class="w-1/2" :class="getTextColor('text-gray-500')">
      <div v-if="component.inputs.length">
        <div class="text-xs font-semibold mb-1">Inputs:</div>
        <div v-for="input in component.inputs" :key="input.id" class="flex items-center gap-2">
          <div class="flex items-center gap-1">
            <div 
              class="w-3 h-3 bg-green-500 rounded-full cursor-pointer hover:ring-2 hover:ring-green-300"
              :class="{'ring-2 ring-green-500 ring-offset-2': selectedOutputId}"
              :data-input-id="input.id"
              :data-component-id="component.id"
              @click.stop="$emit('input-click', input)"
            ></div>
            <button 
              :class="getTextColor('text-gray-500 hover:text-red-700')"
              class="text-xs font-bold export-hide"
              @click.stop="$emit('remove-input', input.id)"
              @mousedown.stop
            >×</button>
            <div v-if="!input.editing" @click="startEditingInput(input)" class="text-xs cursor-pointer flex-1 min-w-0">
              {{ input.name || 'Input name' }}
            </div>
            <input 
              v-else
              v-model="input.name"
              class="text-xs bg-transparent border-b border-gray-300 focus:outline-none flex-1 min-w-0"
              placeholder="Input name"
              @blur="stopEditingInput(input)"
              @keyup.enter="stopEditingInput(input)"
              :ref="el => { if (el) inputRefs[input.id] = el }"
              @click.stop
              @mousedown.stop
            />
          </div>
        </div>
      </div>
    </div>

    <!-- Outputs on right -->
    <div class="w-1/2 pl-2" :class="getTextColor('text-gray-500')">
      <div v-if="component.outputs.length">
        <div class="text-xs font-semibold mb-1">Outputs:</div>
        <div v-for="output in component.outputs" :key="output.id" class="flex items-center gap-2 justify-between">
          <div class="flex items-center gap-1 flex-1">
            <div v-if="!output.editing" @click="startEditingOutput(output)" class="text-xs cursor-pointer flex-1 min-w-0">
              {{ output.name || 'Output name' }}
            </div>
            <input 
              v-else
              v-model="output.name"
              class="text-xs bg-transparent border-b border-gray-300 focus:outline-none flex-1 min-w-0"
              placeholder="Output name"
              @blur="stopEditingOutput(output)"
              @keyup.enter="stopEditingOutput(output)"
              :ref="el => { if (el) outputRefs[output.id] = el }"
              @click.stop
              @mousedown.stop
            />
            <button 
              :class="getTextColor('text-gray-500 hover:text-red-700')"
              class="text-xs font-bold export-hide"
              @click.stop="$emit('remove-output', output.id)"
              @mousedown.stop
            >×</button>
            <div 
              class="w-3 h-3 bg-blue-500 rounded-full cursor-pointer hover:ring-2 hover:ring-blue-300"
              :class="{'ring-2 ring-blue-500 ring-offset-2': selectedOutputId === output.id}"
              :data-output-id="output.id"
              :data-component-id="component.id"
              @click.stop="$emit('output-click', output)"
            ></div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Footer buttons -->
  <div class="flex justify-center gap-2 pt-2 border-t border-gray-200 export-hide">
    <button 
      @click.stop="$emit('add-input')"
      @mousedown.stop
      class="text-xs bg-green-500 text-white px-2 py-1 rounded"
    >
      + Input
    </button>
    <button 
      @click.stop="$emit('add-output')"
      @mousedown.stop
      class="text-xs bg-blue-500 text-white px-2 py-1 rounded"
    >
      + Output
    </button>
  </div>
</template>

<script setup>
import { defineProps, defineEmits, ref, nextTick } from 'vue'

const props = defineProps({
  component: {
    type: Object,
    required: true
  },
  selectedOutputId: {
    type: String,
    default: null
  }
})

const emit = defineEmits([
  'add-input',
  'add-output',
  'remove-input',
  'remove-output',
  'input-click',
  'output-click'
])

const inputRefs = ref({})
const outputRefs = ref({})

const startEditingInput = (input) => {
  input.editing = true
  nextTick(() => {
    inputRefs.value[input.id]?.focus()
  })
}

const stopEditingInput = (input) => {
  input.editing = false
}

const startEditingOutput = (output) => {
  output.editing = true
  nextTick(() => {
    outputRefs.value[output.id]?.focus()
  })
}

const stopEditingOutput = (output) => {
  output.editing = false
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
</script> 