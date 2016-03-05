var camera;
var snapshot; // only one at a time

function startCamera() {
  console.log('starting camera');
  camera = new JpegCamera("#camera");
}

function takeSnapshot() {
  console.log('taking snapshot');
  snapshot = camera.capture().show();

  $('.discard-snapshot, .use-snapshot').removeClass('hidden');
  $('.take-snapshot').addClass('hidden');
}

function discardSnapshot() {
  if (snapshot !== null) {
    snapshot.discard();
    snapshot = null;
  }
  $('.take-snapshot').removeClass('hidden');
  $('.discard-snapshot, .use-snapshot').addClass('hidden');
}

function useSnapshot() {
  if (snapshot !== null) {
    snapshot.upload({ api_url: "/upload_image?id=" + encodeURIComponent($('#badge_employee_id').val()) }).done(function(response) {
      $('#upload_response').html(response);
      // this.discard(); // discard snapshot and show video stream again
    }).fail(function(status_code, error_message, response) {
      $('#upload_response').html("Upload failed with status " + status_code);
    });    
  }
}

function handleLookup() {
  console.log("handling lookup");

  $('.lookup-form')
    .on('ajax:success', function (e, data, status, xhr) {
      console.log('lookup success');
      if (typeof data["name"] === "undefined" || data["name"] === null) {
        $('.lookup-status').text("Employee not found.");
      } else {
        $('.lookup-status').text("");
        $('#badge_name').val(data["name"]);
        $('#badge_department').val(data["department"]);
        $('#badge_title').val(data["title"]);
        $('#badge_employee_id').val(data["employee_id"]);
      }
    })
    .on('ajax:error', function (e, xhr, status, error) {
      console.log('lookup error');
      $('.employee-info').html(error);
    });
}

$(document).ready(handleLookup);
$(document).on('page:load', handleLookup);
