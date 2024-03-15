// summernote에서 이미지 업로드 시 실행할 함수
	function uploadSummernoteImageFile(file, savePath) {
		data = new FormData();
		data.append("file", file);
		$.ajax({
			data : data,
			dataType : "json",
			type : "POST",
			url : "/app/questionBoard/uploadSummernoteImageFile/"+savePath,
			contentType : false,
			processData : false,
			success : function(data) {
				$('#summernote').summernote('insertImage', data.url);
				addFileList(data);
			},
			error : function(data) {
				console.log("업로드 실패", data);
			}
		});
	}
	
		function addFileList(data) {
			let i = fileList.length;
			fileList[i] = data.file;
			console.log(fileList);
		}
		
		
	