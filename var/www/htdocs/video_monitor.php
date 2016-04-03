<?php

define ( 'VIDEO_FOLDER_NAME', 'video_monitor' );
define ( 'VIDEO_FILE_NAME_FORMAT', '/^[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{2}-[0-9]{2}\.(mp4|avi)$/');
define ( 'HTTP_PORT', 8090 );

class VideoFiles {
	public $videoFolderName;

	function getFileNames () {
		$videoFileNames[] = '';
		$videoFolderFiles = scandir( VIDEO_FOLDER_NAME, 1 );
		foreach ( $videoFolderFiles as $key => $videoFolderFile ) {
			if ( preg_match ( VIDEO_FILE_NAME_FORMAT, $videoFolderFile ) == 1 ) {
				array_push ($videoFileNames, $videoFolderFile);
			}
		}
		return $videoFileNames;
	}

}

class Render {

	public $title = '';

	function renderHtml () {
		print ( '<html><head>' );
		print ( "<title>$this->title</title>" );
		print ( '</head><body><div align=center>' );
		print ( "<h1>$this->title</h1>" );
		$this->links();
		print ( '</div></body></html>' );		
	}

	function links () {

		$videoFiles = new VideoFiles;
		$videoFiles->videoFolderName = VIDEO_FOLDER_NAME;
		$server_name = $_SERVER['SERVER_NAME'];
		$http_port = HTTP_PORT;
		echo "<h3><a href=http://$server_name:$http_port/Camera_1>Live Stream</a></h3><br>";

		foreach ( $videoFiles->getFileNames() as $key => $videoFile ) {
			if ( $key > 0 ) {
				echo "Video file #$key: <a href=/", VIDEO_FOLDER_NAME, "/$videoFile>$videoFile</a><br>";
				if ( $key <= 10 ) {
					echo "<video width=\"352\" height=\"288\" controls>";
					echo "<source src=\"$videoFile\" type=\"video/mp4\">";
					echo "Your browser does not support the video tag.";
					echo "</video><br><br>";
				}
			}
		}
	}

}

$render = new Render;
$render->title = 'Video Monitor!';
$render->renderHtml();

?>
