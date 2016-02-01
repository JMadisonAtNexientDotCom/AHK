require([
	'jquery/nyt',
	'blogs/legacy/liveupdates'
], function($, liveUpdates) {
	if ( $( '.is-dashblog' ).length ) {
		return;
	}
	liveUpdates.init();
});