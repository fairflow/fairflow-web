<?php get_header(); ?>

<main id="primary" class="site-main">

<?php while ( have_posts() ) : the_post(); ?>

<article id="page-<?php the_ID(); ?>" <?php post_class( 'entry' ); ?>>

	<header class="entry-header">
		<h1 class="entry-title"><?php the_title(); ?></h1>
	</header>

	<div class="entry-content">
		<?php
		the_content();
		wp_link_pages( [
			'before' => '<nav class="page-links">' . __( 'Pages:', 'fairflow' ),
			'after'  => '</nav>',
		] );
		?>
	</div>

</article>

<?php endwhile; ?>

</main>

<?php get_footer(); ?>
