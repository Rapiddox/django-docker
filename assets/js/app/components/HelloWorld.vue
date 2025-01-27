<script setup lang="ts">
import { ref } from 'vue'

const count = ref(0)
</script>

<template>
  <h1>Hello, World!</h1>
  <button type="button" @click="count++">count is {{ count }}</button>
</template>

<style scoped>

</style>