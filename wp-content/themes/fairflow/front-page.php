<?php get_header(); ?>

<main id="primary" class="site-main">

	<section class="home-intro">
		<?php
		// Show static front page content if set, otherwise a default welcome.
		if ( have_posts() ) :
			while ( have_posts() ) : the_post();
				the_content();
			endwhile;
		else : ?>
		<h2>Welcome to Fairflow Systems Design</h2>
		<p>
			Fairflow Systems Design specialises in computer systems design using
			high-level techniques — functional-first programming, formal specification,
			mathematics, and education.
		</p>
		<p>
			<a href="<?php echo esc_url( get_page_link( get_page_by_path( 'about' ) ) ); ?>">About Fairflow →</a>
			&nbsp;&nbsp;
			<a href="<?php echo esc_url( get_page_link( get_page_by_path( 'matthew' ) ) ); ?>">About Matthew →</a>
			&nbsp;&nbsp;
			<a href="<?php echo esc_url( get_permalink( get_page_by_path( 'services' ) ) ); ?>">Services →</a>
		</p>
		<?php endif; ?>
	</section>

	<?php
	// Recent posts
	$recent = new WP_Query( [
		'post_type'      => 'post',
		'posts_per_page' => 3,
		'post_status'    => 'publish',
	] );

	if ( $recent->have_posts() ) : ?>
	<section class="home-recent">
		<h2>Recent articles</h2>
		<ul class="post-list">
		<?php while ( $recent->have_posts() ) : $recent->the_post(); ?>
			<li class="post-list-item">
				<h3><a href="<?php the_permalink(); ?>"><?php the_title(); ?></a></h3>
				<div class="entry-meta">
					<span><?php echo get_the_date(); ?></span>
					<?php if ( has_category() ) : ?>
					<span class="cat-links"><?php the_category( ', ' ); ?></span>
					<?php endif; ?>
				</div>
				<div class="post-excerpt"><?php the_excerpt(); ?></div>
			</li>
		<?php endwhile; wp_reset_postdata(); ?>
		</ul>
		<p><a href="<?php echo esc_url( get_permalink( get_option( 'page_for_posts' ) ) ); ?>">All articles →</a></p>
	</section>
	<?php endif; ?>

</main>

<?php get_footer(); ?>
