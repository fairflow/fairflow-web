<?php
/**
 * Fairflow theme functions.
 */

// ── Theme setup ─────────────────────────────────────────────────────────────
function fairflow_setup() {
	add_theme_support( 'title-tag' );
	add_theme_support( 'post-thumbnails' );
	add_theme_support( 'automatic-feed-links' );
	add_theme_support( 'html5', [ 'search-form', 'comment-form', 'comment-list', 'gallery', 'caption' ] );
	add_theme_support( 'custom-logo', [
		'height'      => 80,
		'width'       => 300,
		'flex-width'  => true,
		'flex-height' => true,
	] );

	register_nav_menus( [
		'primary' => __( 'Primary Menu', 'fairflow' ),
	] );

	load_theme_textdomain( 'fairflow', get_template_directory() . '/languages' );
}
add_action( 'after_setup_theme', 'fairflow_setup' );

// ── Enqueue styles & scripts ─────────────────────────────────────────────────
function fairflow_enqueue() {
	wp_enqueue_style(
		'fairflow-style',
		get_stylesheet_uri(),
		[],
		wp_get_theme()->get( 'Version' )
	);

	if ( is_singular() && comments_open() && get_option( 'thread_comments' ) ) {
		wp_enqueue_script( 'comment-reply' );
	}
}
add_action( 'wp_enqueue_scripts', 'fairflow_enqueue' );

// ── Wolfram Notebook Embedder (loaded only on pages that need it) ─────────────
function fairflow_enqueue_wolfram() {
	if ( get_post_meta( get_the_ID(), '_fairflow_wolfram', true ) ) {
		wp_enqueue_script(
			'wolfram-embedder',
			'https://www.wolframcloud.com/obj/wolframnotebooks/embedder/WolframNotebookEmbedder.js',
			[],
			null,
			true
		);
	}
}
add_action( 'wp_enqueue_scripts', 'fairflow_enqueue_wolfram' );

// ── Content width ─────────────────────────────────────────────────────────────
if ( ! isset( $content_width ) ) {
	$content_width = 820;
}

// ── Widgets ──────────────────────────────────────────────────────────────────
function fairflow_widgets_init() {
	register_sidebar( [
		'name'          => __( 'Footer Widget Area', 'fairflow' ),
		'id'            => 'footer-1',
		'description'   => __( 'Add widgets here to appear in the footer.', 'fairflow' ),
		'before_widget' => '<section id="%1$s" class="widget %2$s">',
		'after_widget'  => '</section>',
		'before_title'  => '<h3 class="widget-title">',
		'after_title'   => '</h3>',
	] );
}
add_action( 'widgets_init', 'fairflow_widgets_init' );

// ── [wolfram_embed] shortcode ─────────────────────────────────────────────────
// Usage: [wolfram_embed url="https://www.wolframcloud.com/obj/user/notebook"
//         width="800" height="600" fallback_img="/path/to/fallback.gif"
//         download_url="/path/to/file.cdf" download_label="Download CDF"]
function fairflow_wolfram_embed_shortcode( $atts ) {
	$a = shortcode_atts( [
		'url'            => '',
		'width'          => '100%',
		'height'         => '500',
		'fallback_img'   => '',
		'fallback_alt'   => 'Interactive Wolfram notebook',
		'download_url'   => '',
		'download_label' => 'Download notebook',
		'caption'        => '',
	], $atts );

	if ( ! $a['url'] ) {
		return '<p class="wolfram-error">[wolfram_embed: no url provided]</p>';
	}

	// Mark post as needing the embedder script.
	add_post_meta( get_the_ID(), '_fairflow_wolfram', true, true );

	$embed_id = 'wn-' . md5( $a['url'] );
	ob_start();
	?>
	<div class="wolfram-embed">
		<div id="<?php echo esc_attr( $embed_id ); ?>" class="wolfram-embed-target">
			<?php if ( $a['fallback_img'] ) : ?>
			<div class="wolfram-fallback">
				<img src="<?php echo esc_url( $a['fallback_img'] ); ?>"
				     alt="<?php echo esc_attr( $a['fallback_alt'] ); ?>">
				<p>Loading interactive notebook…</p>
			</div>
			<?php endif; ?>
		</div>
		<?php if ( $a['caption'] ) : ?>
		<div class="wolfram-embed-caption"><?php echo esc_html( $a['caption'] ); ?></div>
		<?php endif; ?>
		<?php if ( $a['download_url'] ) : ?>
		<div class="wolfram-embed-caption">
			<a class="wolfram-download" href="<?php echo esc_url( $a['download_url'] ); ?>">
				⬇ <?php echo esc_html( $a['download_label'] ); ?>
			</a>
			&nbsp; Requires <a href="https://www.wolfram.com/player/" target="_blank" rel="noopener">Wolfram Player</a> to open locally.
		</div>
		<?php endif; ?>
	</div>
	<script>
	document.addEventListener('DOMContentLoaded', function () {
		if (typeof WolframNotebookEmbedder !== 'undefined') {
			WolframNotebookEmbedder.embed(
				<?php echo wp_json_encode( $a['url'] ); ?>,
				document.getElementById(<?php echo wp_json_encode( $embed_id ); ?>),
				{ width: <?php echo wp_json_encode( $a['width'] ); ?>,
				  height: <?php echo intval( $a['height'] ); ?> }
			);
		}
	});
	</script>
	<?php
	return ob_get_clean();
}
add_shortcode( 'wolfram_embed', 'fairflow_wolfram_embed_shortcode' );

// ── [service_card] shortcode ─────────────────────────────────────────────────
// Usage: [service_card title="..." price="£200" tagline="..." link="mailto:..."]Content[/service_card]
function fairflow_service_card_shortcode( $atts, $content = '' ) {
	$a = shortcode_atts( [
		'title'   => '',
		'price'   => '',
		'tagline' => '',
		'link'    => 'mailto:matthew@fairflow.co.uk',
	], $atts );

	ob_start();
	?>
	<div class="service-card">
		<?php if ( $a['title'] ) : ?>
		<h3><?php echo esc_html( $a['title'] ); ?></h3>
		<?php endif; ?>
		<?php if ( $a['tagline'] ) : ?>
		<p class="service-tagline"><?php echo esc_html( $a['tagline'] ); ?></p>
		<?php endif; ?>
		<?php if ( $a['price'] ) : ?>
		<p class="service-price"><?php echo esc_html( $a['price'] ); ?></p>
		<?php endif; ?>
		<?php if ( $content ) : ?>
		<div class="service-body"><?php echo wp_kses_post( do_shortcode( $content ) ); ?></div>
		<?php endif; ?>
		<a class="btn" href="<?php echo esc_url( $a['link'] ); ?>">Enquire</a>
	</div>
	<?php
	return ob_get_clean();
}
add_shortcode( 'service_card', 'fairflow_service_card_shortcode' );
