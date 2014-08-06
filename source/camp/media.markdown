---
layout: page
title: "Upload Media"
footer: false
---
Members can use this form to upload media for camp playlists.

<form id="upload-form" action="http://www.playasophy.org.s3.amazonaws.com/" method="post" enctype="multipart/form-data">
  <input type="hidden" name="acl" value="public-read"/>
  <label>Name: <input type="text" name="key" value=""/></label><br/>
  <label>File: <input type="file" name="file"/></label><br/>
  <input type="submit" name="upload" value="Upload"/>
</form>

<div id="uploads" style="display: none;">
  <h3>Uploads</h3>
  <ul id="upload-list">
  </ul>
</div>

<script>
var now = new Date();
var day = now.toISOString().substring(0, 10);

var form = $("#upload-form")[0];

$(form.file).change(function (e) {
  form.key.value = this.value;
});

$(form).submit(function (e) {
  e.preventDefault();
  var file = form.file.value;

  // Must have a file to upload.
  if ( file == "" ) {
    alert("Filename must not be blank");
    return;
  }

  // Use name field for key, default to filename.
  var filename = form.key.value;
  if ( filename == "" ) {
    filename = file;
  }

  // Construct S3 key.
  var key = "media/uploads/" + day + "/" + filename;
  form.key.value = key;

  form.submit();

  // Clear form.
  form.key.value = "";
  form.file.value = "";

  // Add list item marking successful upload.
  $('#uploads').show();
  $('#upload-list').append(
    $('<li/>', {
      html: $('<a/>', {
        href: "http://www.playasophy.org/" + key,
        text: filename
      })
    }));
});
</script>
