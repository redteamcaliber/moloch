(function() {

  'use strict';

  /**
   * @class UploadController
   * @classdesc Interacts with moloch upload page
   * @example
   * '<moloch-upload></moloch-upload>'
   */
  class UploadController {

    /**
     * Initialize global variables for this controller
     * @param UploadService Uploads a pcap to the server
     *
     * @ngInject
     */
    constructor(UploadService) {
      this.UploadService = UploadService;
    }

    /* Callback when component is mounted and ready */
    $onInit() {}

    upload() {
      // TODO form validation

      this.uploading = true;

      this.UploadService.upload(this.file, this.tag)
        .then((response) => {
          this.uploading = false;
          // display success message to user
          this.msg = response.text;
          this.msgType = 'success';
        })
        .catch((error) => {
          this.uploading = false;
          // display success message to user
          this.msg = error;
          this.msgType = 'danger';
        });
    }

  }

  UploadController.$inject = ['UploadService'];

  /**
   * Moloch Upload Directive
   * Displays upload form
   */
  angular.module('moloch')
    .component('molochUpload', {
      template  : require('html!./upload.html'),
      controller: UploadController
    })

  .directive('fileread', [function () {
    return {
      scope: { fileread: '=' },
      link: function (scope, element) {
        element.bind('change', function (changeEvent) {
          let reader = new FileReader();
          reader.onload = (loadEvent) => {
            scope.$apply(function () {
              scope.fileread = loadEvent.target.result;
            });
          };
          reader.readAsDataURL(changeEvent.target.files[0]);
        });
      }
    };
  }]);

})();
