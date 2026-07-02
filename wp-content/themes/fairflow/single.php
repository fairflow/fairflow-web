<?php get_header(); ?>

<main id="primary" class="site-main">

<?php while ( have_posts() ) : the_post(); ?>

<article id="post-<?php the_ID(); ?>" <?php post_class( 'entry' ); ?>>

	<header class="entry-header">
		<h1 class="entry-title"><?php the_title(); ?></h1>
		<div class="entry-meta">
			<span><?php echo get_the_date(); ?></span>
			<?php if ( has_category() ) : ?>
			<span class="cat-links"><?php the_category( ', ' ); ?></span>
			<?php endif; ?>
			<?php if ( has_tag() ) : ?>
			<span class="tags-links"><?php the_tags( '', ', ' ); ?></span>
			<?php endif; ?>
		</div>
	</header>

	<div class="entry-content">
		<?php the_content(); ?>
		<?php
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
