<template>
  <div class="flex justify-between items-center mb-4">
    <div class="flex gap-2">
      <div class="relative">
        <button
          class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
          @click="showDropdown = !showDropdown"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z" clip-rule="evenodd" />
          </svg>
        </button>
        <div v-if="showDropdown" class="absolute z-10 mt-2 w-48 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5">
          <div class="py-1">
            <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100" @click.prevent="addComponent('component')">Component</a>
            <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100" @click.prevent="addComponent('notice')">Notice</a>
          </div>
        </div>
      </div>
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
import { defineEmits, ref } from 'vue'

const showDropdown = ref(false)

const emit = defineEmits(['add-component', 'zoom', 'export-png', 'export-pdf'])

const addComponent = (type) => {
  emit('add-component', type)
  showDropdown.value = false
}
</script>
