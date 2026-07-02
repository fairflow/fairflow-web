<?php get_header(); ?>

<main id="primary" class="site-main">

<header class="page-header">
	<h1 class="page-title">
		<?php
		if ( is_category() ) {
			echo 'Category: ' . single_cat_title( '', false );
		} elseif ( is_tag() ) {
			echo 'Tag: ' . single_tag_title( '', false );
		} elseif ( is_author() ) {
			echo 'Author: ' . get_the_author();
		} elseif ( is_year() ) {
			echo get_the_date( 'Y' );
		} elseif ( is_month() ) {
			echo get_the_date( 'F Y' );
		} else {
			esc_html_e( 'Archives', 'fairflow' );
		}
		?>
	</h1>
</header>

<?php if ( have_posts() ) : ?>
<ul class="post-list">
<?php while ( have_posts() ) : the_post(); ?>
	<li class="post-list-item">
		<h2><a href="<?php the_permalink(); ?>"><?php the_title(); ?></a></h2>
		<div class="entry-meta">
			<span><?php echo get_the_date(); ?></span>
			<?php if ( has_category() ) : ?>
			<span class="cat-links"><?php the_category( ', ' ); ?></span>
			<?php endif; ?>
		</div>
		<div class="post-excerpt"><?php the_excerpt(); ?></div>
	</li>
<?php endwhile; ?>
</ul>
<?php the_posts_pagination(); ?>
<?php else : ?>
	<p><?php esc_html_e( 'No posts found.', 'fairflow' ); ?></p>
<?php endif; ?>

</main>

<?php get_footer(); ?>
