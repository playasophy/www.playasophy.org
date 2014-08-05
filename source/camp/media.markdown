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
$("#upload-form").submit(function (e) {
  e.preventDefault();
  var form = this;
  var filename = form['key'].value;
  var key = "media/uploads/" + day + "/" + filename;

  if ( filename == "" ) {
    alert("Filename must not be blank");
  } else {
    form['key'].value = key;
    form.submit();
    form['key'].value = "";
    form['file'].value = "";
    $('#upload-list').append(
      $('<li/>', {
        html: $('<a/>', {
          href: "http://www.playasophy.org/" + key,
          text: filename
        })}));
    $('#uploads').show();
  }
});
</script>
