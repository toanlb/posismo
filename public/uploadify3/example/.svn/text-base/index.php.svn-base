<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<title>JQuery File Upload Plugin Script - Uploadify</title>
<meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
<meta http-equiv="content-language" content="pt" />
<meta http-equiv="cache-control" content="no-cache" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="expires" content="0" />

<meta name="description" content="JQuery File Upload Plugin Script - Uploadify" />
<meta name="keywords" content="uploadify" />
<meta name="robots" content="noindex,nofollow" />
<meta name="googlebot" content="noindex,nofollow" />
<meta name="google" value="notranslate" />
<meta name="author" content="wdwebdesigner.com.br" />
<meta name="version" content="2.0" />
<meta name="copyrigt" content="Copyright (c) 2009-2011" />
<meta name="rating" content="general" />

<script type="text/javascript" src="/jquery.1.6.2/jquery.1.6.2.min.js"></script>

<link type="text/css" rel="stylesheet" href="/jquery.uploadify-v3.0.0/uploadify.css" />
<script type="text/javascript" src="/jquery.uploadify-v3.0.0/jquery.uploadify.min.js"></script>
<script type="text/javascript" src="/jquery.uploadify-v3.0.0/flash_detect.1.0.4.min.js"></script>

<script type="text/javascript">
function doFormSubmit() {
	// GRAB FIELDS VALUES AND SEND TO uploadify.php, YOU CAN DO WHATEVER YOU WANT WITH THEM IN uploadify.php FILE
	$('#gallery').uploadifySettings('postData', {'field1':$('#field1').val(),'field2':$('#field2').val(),'field3':$('#field3').val(),'field4':$('#field4').val(),'field5':$('#field5').val()});

	// UPLOAD IMAGES
	$('#gallery').uploadifyUpload();
}

$(document).ready(function() {
	// Verify if Flash Player is Installed and if Flash Player version is 9 or higher
	if (!FlashDetect.versionAtLeast(9)) {
		// You can have an invisible DIV that contains an alternative form input box to upload files without uploadify, when Flash Detect Fails, you set it to visible and handle things the way you want, you can use this error control to do whatever you want if user has no Flash Player Inslalled.
		$("#gallery").html('You do not have Flash Player installed or your Flash Player is too old!<br>Please install Flash Player 9 or higher.');
	} else {
		var img = 0;
		$("#gallery").uploadify({
			// Required Settings
			langFile : '/jquery.uploadify-v3.0.0/uploadifyLang_en.js',
			swf : '/jquery.uploadify-v3.0.0/uploadify.swf',
			uploader : '/jquery.uploadify-v3.0.0/uploadify.php',

			// Options - HERE ARE ALL USEFUL OPTIONS, DON'T USE ANYTHING THAT ISN'T LISTED HERE
			'debug'           : false, // DON'T SET THIS TO TRUE UNLESS YOU NEED TO SEE IF THERE IS ANY ERROR IN YOUR SCRIPT, IN YOUR SITE, JUST DON'T USE THIS OPTION AT ALL
			'auto'            : false,
			'buttonText'      : 'Select Images',
			'width'           : 150,
			'height'          : 30,
			'cancelImage'     : '/jquery.uploadify-v3.0.0/uploadify-cancel.png',
			'checkExisting'   : '/jquery.uploadify-v3.0.0/uploadify-check-existing.php',
			'fileSizeLimit'   : 1*1024*1024, // 1MB
			'fileTypeDesc'    : 'Image Files',
			'fileTypeExts'    : '*.gif;*.jpg;*.png',
			'method'          : 'post',
			'multi'           : true,
			'queueID'         : 'fileQueue',
			'queueSizeLimit'  : 999,
			'removeCompleted' : true,
			'postData'        : {},
			'progressData'    : 'all',

			onUploadSuccess : function(file,data,response) {
				$("#myForm").append("<input type='hidden' id='img"+img+"' name='img"+img+"' value='"+data+"' />"); // INSERT IMAGE FILENAME IN A HIDDEN FORM FIELD
				img++;
			},

			onQueueComplete: function (stats) {
				$("#myForm").append("<input type='hidden' id='numImgs' name='numImgs' value='"+img+"' />"); // INSERT NUMBER OF IMAGES UPLOADED IN A HIDDEN FORM FIELD
				$('#myForm').submit(); // THIS IS AN EXAMPLE, YOU CAN SUBMIT YOUR INFOS WITH AJAX IF YOU WANT
			}
		});
	}
});
</script>

</head>

<body>

<?
// THIS IS AN EXAMPLE, YOU CAN GRAB THIS INFOS VIA AJAX TO INSERT IN YOUR DATABASE
$submitting = $_REQUEST['submitting'];
if ($submitting == 'yes') {
	// REQUEST POST INFOS
	$field1 = $_REQUEST['field1'];
	$field2 = $_REQUEST['field2'];
	$field3 = $_REQUEST['field3'];
	$field4 = $_REQUEST['field4'];
	$field5 = $_REQUEST['field5'];
	$numImgs = $_REQUEST['numImgs'];
	for ($i = 0; $i <= $numImgs; $i++) {
		$img[$i] = $_REQUEST['img'.$i];
	}

	// DISPLAY POST INFOS - YOU CAN DO WHATEVER YOU WANT WITH THIS
	echo 'field1: '.$field1.'<br>';
	echo 'field2: '.$field2.'<br>';
	echo 'field3: '.$field3.'<br>';
	echo 'field4: '.$field4.'<br>';
	echo 'field5: '.$field5.'<br>';
	for ($i = 0; $i <= $numImgs; $i++) {
		if ((isset($img[$i])) && ($img[$i] != '')) {
			echo 'image'.$i.': '. $img[$i].'<br>';
		}
	}
	echo '<br>';
}
?>

<font style='font-size: 18px;'>In this example, this fields values will be sent to uploadify.php and you can work with them there. Also, every image uploaded will be stored in the FORM so you can submit them to your database after you uploaded all your images. Take a look at the code to see how it works.</font>
<br><br>

<form name='myForm' id='myForm' method='post' action='<?=$_SERVER['PHP_SELF']?>'>
<input type='hidden' id='submitting' name='submitting' value='yes' />

<table width='600' border='0' cellspacing='0' cellpadding='2' align='center'><tr>
<td align='left'>Fields that will go through <b>postData</b> variables to <b>uploadify.php</b>:</td>
</tr></table>
<table width='600' border='0' rules='none' frame='box' style='background-color: #FFFFFF; border: 1px solid #CC0000;' cellspacing='0' cellpadding='5' align='center'>
<tr><td align='right'>Field 1:</td><td align='left'><input type='text' style='width: 300px;' name='field1' id='field1' value=''></td></tr>
<tr><td align='right'>Field 2:</td><td align='left'><input type='text' style='width: 300px;' name='field2' id='field2' value=''></td></tr>
<tr><td align='right'>Field 3:</td><td align='left'><input type='text' style='width: 300px;' name='field3' id='field3' value=''></td></tr>
<tr><td align='right'>Field 4:</td><td align='left'><input type='text' style='width: 300px;' name='field4' id='field4' value=''></td></tr>
<tr><td align='right'>Field 5:</td><td align='left'><input type='text' style='width: 300px;' name='field5' id='field5' value=''></td></tr>
</table>

<br><br>

<table width='600' border='0' cellspacing='0' cellpadding='2' align='center'><tr>
<td align='left'>Images:</td>
<td align='right'><font style='font-size:10px;'><a href='#' onclick="jQuery('#gallery').uploadifyCancel('*'); return false;">(Clear Images List)</a></font></td>
</tr></table>
<table width='600' border='0' rules='none' frame='box' style='background-color: #FFFFFF; border: 1px solid #1f6798;' cellspacing='0' cellpadding='5' align='center'>
<tr><td align='center'>
<div id='gallery'>You've got a problem with your JavaScript</div>
</td></tr>
</table>

<br><br>

<table width='600' border='0' cellspacing='0' cellpadding='2' align='center'><tr>
<td align='left'>fileQueue:</td>
</tr></table>
<table width='600' border='0' rules='none' frame='box' style='background-color: #FFFFFF; border: 1px solid #CC0000;' cellspacing='0' cellpadding='5' align='center'>
<tr><td align='center'>
<div id='fileQueue'></div>
</td></tr>
</table>

<br>

<center><button type="button" name="btSubmit" id="btSubmit" onclick="doFormSubmit()">Upload and Submit</button></center>

<br>

</form>

</body>
</html>