<template>
  <div class="mb-2 relative flex items-start">
    <div class="flex-1">
      <div v-if="!component.editingName" @click="startEditingName" :class="[getTextColor('font-semibold'), 'cursor-pointer']">
        {{ component.name }}
      </div>
      <input
        v-else
        v-model="component.name"
        :class="[getTextColor('font-semibold'), 'bg-transparent focus:outline-none w-full']"
        @blur="stopEditingName"
        @keyup.enter="stopEditingName"
        ref="nameInput"
        @click.stop
      />

      <div v-if="!component.editingType" @click="startEditingType" :class="[getTextColor('text-sm'), 'cursor-pointer']">
        {{ component.type }}
      </div>
      <input
        v-else
        v-model="component.type"
        :class="[getTextColor('text-sm'), 'bg-transparent focus:outline-none w-full']"
        @blur="stopEditingType"
        @keyup.enter="stopEditingType"
        ref="typeInput"
        @click.stop
      />
    </div>
  </div>
</template>

<script setup>
import { defineProps, defineEmits, ref, nextTick } from 'vue'

const emit = defineEmits([])

const props = defineProps({
  component: {
    type: Object,
    required: true
  }
})

const nameInput = ref(null)
const typeInput = ref(null)

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