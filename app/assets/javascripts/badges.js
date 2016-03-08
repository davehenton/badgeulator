var camera;
var snapshot; // only one at a time

function startCamera() {
  if ($('#camera').length == 1) {
    console.log('starting camera');
    camera = new JpegCamera("#camera");
  }
}

function takeSnapshot() {
  console.log('taking snapshot');
  snapshot = camera.capture().show();

  $('.retake-snapshot, .use-snapshot').removeClass('hidden');
  $('.take-snapshot').addClass('hidden');
}

function discardSnapshot() {
  console.log('discarding snapshot');
  if (snapshot !== null) {
    snapshot.discard();
    snapshot = null;
  }
  $('#upload_response').html('');
  $('#cropbox').addClass("hidden");
  $('#camerabox').removeClass("hidden");
  $('.take-snapshot').removeClass('hidden');
  $('.retake-snapshot, .use-snapshot').addClass('hidden');
}

function useSnapshot() {
  console.log('uploading snapshot');
  if (snapshot !== null) {
    snapshot.upload({ api_url: $('.use-snapshot').data('url') }).done(function(response) {
      $('#camerabox').addClass("hidden");
      $('#cropbox img').attr('src', response);
      $('#cropbox').removeClass("hidden");
      $('#cropbox img').Jcrop({ 
        aspectRatio: 0.692, 
        setSelect: [0, 0, 150, 200],
        onChange: updateCrop,
        onSelect: updateCrop
      });
    }).fail(function(status_code, error_message, response) {
      $('#upload_response').html("Upload failed with status " + status_code);
    });    
  }
}

function updateCrop(coords) {
  console.log('setting coordinates');
  $('.crop-snapshot').data('coords', coords);
}

function cropSnapshot() {
  $.ajax($('.crop-snapshot').data('url'), { data: $('.crop-snapshot').data('coords') });
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
