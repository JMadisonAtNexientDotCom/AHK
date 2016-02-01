require(['jquery/nyt'], function($) {
	$(document).ready(function () {
		$('.toggleContent').on('click', '.showContent', function() {
			$(this).hide().parents('.toggleContent').find('.hiddenContent').slideDown('fast');
		});
		$('#content').on('click', '.toggle-more-link', function() {
			$(this).hide().parents('.post-text,.entry-content').find('.toggle-content').slideDown('fast').removeClass('hidden');
		});
		$('.entry-content').on('click', '.st', function() {
			$('.stndrd').removeClass('hidden').slideDown('fast');
			$(this).hide();
			return false;
		});
	});
});