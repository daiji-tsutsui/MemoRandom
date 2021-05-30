function selectFile(input) {
  var files = input.files;
  var fileCount = files.length;
  if (fileCount === 0){
    document.getElementById("filename").classList.add("hidden");
  } else {
    list = document.getElementById("filename");
    list.classList.remove("hidden");
    while( list.firstChild ){
      list.removeChild( list.firstChild );
    }
    for (i = 0; i < fileCount; i++) {
      var item = document.createElement('li');
      item.innerHTML = files[i].name;
      list.appendChild(item);
    }
  }
}
