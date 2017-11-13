<template>
  <md-dialog-prompt
    :md-title="prompt.title"
    :md-ok-text="prompt.ok"
    :md-cancel-text="prompt.cancel"
    :md-input-maxlength="prompt.maxlength"
    :md-input-placeholder="prompt.placeholder"
    @open="onOpen"
    @close="onClose"
    v-model="prompt.value"
    ref="dialog6">
  </md-dialog-prompt>
</template>


<script>
  export default {
     name: 'ProjectsCreate',
    data: () => ({
      prompt: {
        title: 'What\'s your name?',
        ok: 'Done',
        cancel: 'Cancel',
        id: 'name',
        name: 'name',
        placeholder: 'Type your name...',
        maxlength: 30,
        value: ''
      }
    }),
    methods: {
      openDialog(ref) {
        this.$refs[ref].open();
      },
      closeDialog(ref) {
        this.$refs[ref].close();
      },
      onOpen() {
        console.log('Opened');
      },
      onClose(type) {
        console.log('Closed', type);
      }
    }
  };
</script>