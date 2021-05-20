function selectFile() {
    if (document.getElementById("post_memo").value === ""){
        document.getElementById("filename").classList.add("hidden");
    } else {
        document.getElementById("filename").classList.remove("hidden");
        document.getElementById("filename").innerHTML = document.getElementById("post_memo").value;
    }
}
