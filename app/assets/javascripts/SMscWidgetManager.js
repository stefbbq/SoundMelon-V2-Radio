//scWidget manager

var SMscWidgetManager = function() {
	var allSongs = [];

	function destroySong(sID) {
		soundManager.destroySound(sID);
	}

	function addSong(song) {
		allSongs.push(song);
	}

	function stopAll() {
		for(var i=0; i < allSongs.length; i++) {
			destroySong(allSongs[i].sID);
		}
		console.log(allSongs);
	}

	return {
		destroySong: destroySong,
		addSong: addSong,
		stopAll: stopAll
	}
}