<template>
  <div
    class="absolute cursor-move"
    :style="{
      left: `${notice.x}px`,
      top: `${notice.y}px`,
      backgroundColor: notice.color,
      color: getTextColor(notice.color),
      zIndex: 90
    }"
    @mousedown="$emit('drag-start', $event, notice)"
  >
    <div class="p-4 rounded-lg shadow-lg min-w-[200px]">
      <!-- Header with delete and color buttons -->
      <div class="flex justify-end gap-2 mb-2 export-hide">
        <button
          :class="`hover:text-gray-800 ${getTextColor(notice.color)}`"
          @click="$emit('color-pick', notice)"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M4 2a2 2 0 00-2 2v11a3 3 0 106 0V4a2 2 0 00-2-2H4zm1 14a1 1 0 100-2 1 1 0 000 2zm5-1.757l4.9-4.9a2 2 0 000-2.828L13.485 5.1a2 2 0 00-2.828 0L10 5.757v8.486zM16 18H9.071l6-6H16a2 2 0 012 2v2a2 2 0 01-2 2z" clip-rule="evenodd" />
          </svg>
        </button>
        <button
          :class="`hover:text-red-600 ${getTextColor(notice.color)}`"
          @click="$emit('delete', notice.id)"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z" clip-rule="evenodd" />
          </svg>
        </button>
      </div>

      <!-- Editable Label -->
      <div
        class="min-h-[50px] break-words"
        @dblclick="startEditing"
      >
        <textarea
          v-if="isEditing"
          v-model="notice.text"
          class="w-full p-2 border rounded"
          :style="{ color: getTextColor(notice.color) }"
          @blur="stopEditing"
          @keydown.enter="stopEditing"
          ref="textArea"
        ></textarea>
        <div v-else class="whitespace-pre-wrap" :class="getTextColor(notice.color)">{{ notice.text || 'Double click to edit' }}</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const props = defineProps({
  notice: {
    type: Object,
    required: true
  }
})

defineEmits(['delete', 'color-pick', 'drag-start'])

const isEditing = ref(false)
const textArea = ref(null)

const startEditing = () => {
  isEditing.value = true
  setTimeout(() => {
    textArea.value?.focus()
  })
}

const stopEditing = () => {
  isEditing.value = false
}

const getTextColor = (backgroundColor) => {
  // Convert hex to RGB
  const hex = backgroundColor.replace('#', '')
  const r = parseInt(hex.substr(0, 2), 16)
  const g = parseInt(hex.substr(2, 2), 16)
  const b = parseInt(hex.substr(4, 2), 16)
  
  // Calculate relative luminance
  const luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255
  
  // Return black for light backgrounds and white for dark backgrounds
  return luminance > 0.6 ? 'text-gray-900' : 'text-white'
}
</script> 