<?php get_header(); ?>

<main id="primary" class="site-main">
	<article class="entry error-404">
		<header class="entry-header">
			<h1 class="entry-title"><?php esc_html_e( 'Page not found', 'fairflow' ); ?></h1>
		</header>
		<div class="entry-content">
			<p><?php esc_html_e( 'The page you were looking for could not be found. It may have moved.', 'fairflow' ); ?></p>
			<?php get_search_form(); ?>
		</div>
	</article>
</main>

<?php get_footer(); ?>
