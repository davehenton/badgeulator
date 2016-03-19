var camera;
var snapshot;   // only one at a time
var jcrop_api;

function startCamera() {
  if ($('#camera').length == 1) {
    console.log('starting camera');
    camera = new JpegCamera("#camera");
  }
}

function takeSnapshot() {
  console.log('taking snapshot');
  snapshot = camera.capture({ mirror: true }).show();

  //$('.retake-snapshot, .use-snapshot').removeClass('hidden');
  $('.take-snapshot').addClass('hidden');

  console.log('uploading snapshot');
  if (snapshot !== null) {
    snapshot.upload({ api_url: $('.use-snapshot').data('url') }).done(function(response) {
      $('.retake-snapshot').removeClass('hidden');
      $('#camerabox').addClass("hidden");
      $('#cropbox img').attr('src', response);
      $('#cropbox').removeClass("hidden");
      $('#cropbox img').Jcrop({ 
        aspectRatio: 0.85, 
        setSelect: [0, 0, 170, 200],
        onChange: updateCrop,
        onSelect: updateCrop
      }, function() {
        jcrop_api = this;
      });
      $('.step-take').removeClass("step-active");
      $('.step-crop').addClass("step-active");
    }).fail(function(status_code, error_message, response) {
      $('#upload_response').html("Upload failed with status " + status_code);
    });
  }
}

function discardSnapshot() {
  console.log('discarding snapshot');
  if (jcrop_api !== null) {
    jcrop_api.destroy();
    jcrop_api = null;
  }
  if (snapshot !== null) {
    snapshot.discard();
    snapshot = null;
  }
  $('#upload_response').html('');
  $('#cropbox').addClass("hidden");
  $('#camerabox').removeClass("hidden");
  $('.take-snapshot').removeClass('hidden');
  $('.retake-snapshot, .use-snapshot').addClass('hidden');
  $('.step-take').addClass("step-active");
  $('.step-crop').removeClass("step-active");
}

function updateCrop(coords) {
  console.log('setting coordinates');
  $('.crop-snapshot').data('coords', coords);
}

function cropSnapshot() {
  console.log('cropping the snapshot');
  $('button.retake2-snapshot').prop('disabled', true);
  $('button.crop-snapshot').html('<i class="fa fa-spin fa-spinner"></i> Working...').prop('disabled', true);
  $.ajax($('.crop-snapshot').data('url'), { data: $('.crop-snapshot').data('coords') })
  .success(function (data, status, jqxhr) {
    console.log('successfully cropped snapshot');

    window.location = data['url'];
  });
}

function handleLookup() {
  console.log("handling lookup");

  $('.lookup-form')
    .on('ajax:success', function (e, data, status, xhr) {
      console.log('lookup success');
      if (typeof data["first_name"] === "undefined" || data["first_name"] === null) {
        $('.lookup-status').text("Employee not found.");
        $('#badge_first_name, #badge_last_name, #badge_department, #badge_title, #badge_employee_id, #badge_dn').val('');
      } else {
        $('.lookup-status').text("");
        $('#badge_first_name').val(data["first_name"]);
        $('#badge_last_name').val(data["last_name"]);
        $('#badge_department').val(data["department"]);
        $('#badge_title').val(data["title"]);
        $('#badge_employee_id').val(data["employee_id"]);
        $('#badge_dn').val(data["dn"]);
      }
    })
    .on('ajax:error', function (e, xhr, status, error) {
      console.log('lookup error');
      $('.employee-info').html(error);
    })
    .on('submit', function () {
      if ($('#employee_id').val().trim() == '') {
        $('.lookup-status').text("Employee ID is required for lookup.");
        return false;
      } else {
        $('.lookup-status').text("Searching...");
      }
    });

  // wireup generate button
  $(document).on('click', 'a.generate-badge', function () {
    $(this).html('<i class="fa fa-spin fa-spinner"></i> Generating...').addClass('disabled');
  });
}

$(document).ready(handleLookup);
$(document).on('page:load', handleLookup);
