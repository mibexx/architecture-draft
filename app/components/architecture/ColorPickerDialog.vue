<template>
  <div v-if="show" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
    <div class="bg-white p-4 rounded-lg shadow-lg">
      <h3 class="text-lg font-bold mb-4">Select Component Color</h3>
      <div class="grid grid-cols-5 gap-2 mb-4">
        <button
          v-for="color in colors"
          :key="color"
          class="w-8 h-8 rounded-full border-2"
          :style="{ backgroundColor: color, borderColor: selectedColor === color ? '#000' : 'transparent' }"
          @click="selectColor(color)"
        ></button>
      </div>
      <div class="flex justify-end gap-2">
        <button 
          class="px-4 py-2 bg-gray-200 rounded"
          @click="$emit('close')"
        >
          Cancel
        </button>
        <button 
          class="px-4 py-2 bg-blue-500 text-white rounded"
          @click="handleDone"
        >
          Done
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { defineProps, defineEmits, ref } from 'vue'

const colors = [
  '#f3f4f6',
  '#fee2e2',
  '#fef3c7',
  '#dcfce7',
  '#dbeafe',
  '#f3e8ff'
]

const props = defineProps({
  show: {
    type: Boolean,
    required: true
  },
  selectedColor: {
    type: String,
    default: '#f3f4f6'
  }
})

const emit = defineEmits(['close', 'select-color'])

const tempSelectedColor = ref(props.selectedColor)

const selectColor = (color) => {
  tempSelectedColor.value = color
  emit('select-color', color)
}

const handleDone = () => {
  emit('close')
}
</script> 