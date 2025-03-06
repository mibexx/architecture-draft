<template>
  <div>
    <div v-if="!isEditing" @click="$emit('start-edit')" class="cursor-pointer">
      {{ value || placeholder }}
    </div>
    <input
      v-else
      :value="value"
      :placeholder="placeholder"
      class="bg-transparent focus:outline-none w-full"
      @blur="$emit('stop-edit')"
      @keyup.enter="$emit('stop-edit')"
      @input="$emit('update:value', $event.target.value)"
      ref="input"
      @click.stop
      @mousedown.stop
    />
  </div>
</template>

<script setup>
import { defineProps, defineEmits } from 'vue'

defineProps({
  value: {
    type: String,
    default: ''
  },
  isEditing: {
    type: Boolean,
    default: false
  },
  placeholder: {
    type: String,
    default: ''
  }
})

defineEmits(['start-edit', 'stop-edit', 'update:value'])
</script> 