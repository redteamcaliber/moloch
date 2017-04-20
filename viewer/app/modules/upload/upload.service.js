(function() {

  'use strict';

  /**
   * @class UploadService
   * @classdesc Uploads a pcap to the server
   */
  class UploadService {

    /**
     * Initialize global variables for the UploadService
     * @param $q    Service to run functions asynchronously
     * @param $http Angular service that facilitates communication
     *              with the remote HTTP servers
     *
     * @ngInject
     */
    constructor($q, $http) {
      this.$q     = $q;
      this.$http  = $http;
    }

    /* service methods ----------------------------------------------------- */
    /**
     * Uploads a pcap to the server
     * @param   {file} file       The file to send
     * @param   {string} tag      The tag to append to the session created
     * @returns {Promise} Promise A promise object that signals the completion
     *                            or rejection of the request.
     */
    upload(file, tag) {
      return this.$q((resolve, reject) => {

        let formData = new FormData();
        formData.append('files', file);
        formData.append('tag', tag);

        let options = {
          method          :'POST',
          url             :'upload',
          data            : formData,
          transformRequest: angular.identity,
          headers         : { 'Content-Type': undefined }
        };

        this.$http(options)
          .then((response) => {
            resolve(response.data);
          }, (error) => {
            reject(error);
          });
      });
    }

  }

  UploadService.$inject = ['$q', '$http'];


  angular.module('moloch')
    .service('UploadService', UploadService);

})();
