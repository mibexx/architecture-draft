<template>
  <div class="mb-2 relative flex items-center">
    <!-- Color picker button -->
    <button
      class="text-gray-500 hover:text-gray-700 mr-2 export-hide"
      @click.stop="$emit('color-pick', component)"
      @mousedown.stop
    >
      <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
        <path fill-rule="evenodd" d="M4 2a2 2 0 00-2 2v11a3 3 0 106 0V4a2 2 0 00-2-2H4zm1 14a1 1 0 100-2 1 1 0 000 2zm5-1.757l4.9-4.9a2 2 0 000-2.828L13.485 5.1a2 2 0 00-2.828 0L5.757 10l4.9 4.243zm-5-9.243a1 1 0 100-2 1 1 0 000 2z" clip-rule="evenodd" />
      </svg>
    </button>

    <div class="flex-1">
      <div v-if="!component.editingName" @click="startEditingName" class="font-semibold text-gray-800 cursor-pointer">
        {{ component.name }}
      </div>
      <input
        v-else
        v-model="component.name"
        class="font-semibold text-gray-800 bg-transparent focus:outline-none w-full"
        @blur="stopEditingName"
        @keyup.enter="stopEditingName"
        ref="nameInput"
        @click.stop
      />

      <div v-if="!component.editingType" @click="startEditingType" class="text-sm text-gray-600 cursor-pointer">
        {{ component.type }}
      </div>
      <input
        v-else
        v-model="component.type"
        class="text-sm text-gray-600 bg-transparent focus:outline-none w-full"
        @blur="stopEditingType"
        @keyup.enter="stopEditingType"
        ref="typeInput"
        @click.stop
      />
    </div>

    <!-- Delete component button -->
    <button
      class="text-red-500 hover:text-red-700 ml-2 export-hide"
      @click.stop="$emit('delete')"
      @mousedown.stop
    >
      <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
        <path fill-rule="evenodd" d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z" clip-rule="evenodd" />
      </svg>
    </button>
  </div>
</template>

<script setup>
import { defineProps, defineEmits, ref, nextTick } from 'vue'

const props = defineProps({
  component: {
    type: Object,
    required: true
  }
})

const emit = defineEmits([
  'delete',
  'color-pick'
])

const nameInput = ref(null)
const typeInput = ref(null)

const startEditingName = () => {
  props.component.editingName = true
  nextTick(() => {
    nameInput.value?.focus()
  })
}

const stopEditingName = () => {
  props.component.editingName = false
}

const startEditingType = () => {
  props.component.editingType = true
  nextTick(() => {
    typeInput.value?.focus()
  })
}

const stopEditingType = () => {
  props.component.editingType = false
}
</script> 