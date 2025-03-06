<template>
  <div class="flex justify-between items-center mb-4">
    <div class="flex gap-2">
      <button
        class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
        @click="$emit('add-component')"
      >
        Add Component
      </button>
      <button
        class="px-4 py-2 bg-gray-200 rounded hover:bg-gray-300"
        @click="$emit('zoom', 0.1)"
      >
        Zoom In
      </button>
      <button
        class="px-4 py-2 bg-gray-200 rounded hover:bg-gray-300"
        @click="$emit('zoom', -0.1)"
      >
        Zoom Out
      </button>
    </div>
    <div class="flex gap-2">
      <button
        class="px-4 py-2 bg-gray-200 rounded hover:bg-gray-300"
        @click="$emit('export-png')"
      >
        Export PNG
      </button>
      <button
        class="px-4 py-2 bg-gray-200 rounded hover:bg-gray-300"
        @click="$emit('export-pdf')"
      >
        Export PDF
      </button>
    </div>
  </div>
</template>

<script setup>
import { defineEmits } from 'vue'

defineEmits(['add-component', 'zoom', 'export-png', 'export-pdf'])
</script>