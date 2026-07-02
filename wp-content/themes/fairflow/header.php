<!DOCTYPE html>
<html <?php language_attributes(); ?>>
<head>
<meta charset="<?php bloginfo( 'charset' ); ?>">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="profile" href="https://gmpg.org/xfn/11">
<?php wp_head(); ?>
</head>

<body <?php body_class(); ?>>
<?php wp_body_open(); ?>

<a class="screen-reader-text" href="#main-content"><?php esc_html_e( 'Skip to content', 'fairflow' ); ?></a>

<header class="site-header" role="banner">
	<div class="wrap">
		<div class="site-branding">
			<?php if ( has_custom_logo() ) : ?>
				<?php the_custom_logo(); ?>
			<?php else : ?>
				<a class="site-title" href="<?php echo esc_url( home_url( '/' ) ); ?>" rel="home">
					<?php bloginfo( 'name' ); ?>
				</a>
			<?php endif; ?>
			<?php
			$description = get_bloginfo( 'description', 'display' );
			if ( $description ) : ?>
			<p class="site-description"><?php echo esc_html( $description ); ?></p>
			<?php endif; ?>
		</div>
	</div>
</header>

<nav class="main-navigation" role="navigation" aria-label="<?php esc_attr_e( 'Primary menu', 'fairflow' ); ?>">
	<div class="wrap">
		<?php
		wp_nav_menu( [
			'theme_location' => 'primary',
			'menu_class'     => 'primary-menu',
			'container'      => false,
			'fallback_cb'    => 'fairflow_fallback_menu',
		] );
		?>
	</div>
</nav>

<div id="main-content" class="site-content">
<?php
function fairflow_fallback_menu() {
	echo '<ul class="primary-menu">';
	echo '<li><a href="' . esc_url( home_url( '/' ) ) . '">Home</a></li>';
	wp_list_pages( [ 'title_li' => '', 'depth' => 1 ] );
	echo '</ul>';
}
