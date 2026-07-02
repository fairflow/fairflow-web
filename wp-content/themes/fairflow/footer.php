</div><!-- #main-content -->

<footer class="site-footer" role="contentinfo">
	<div class="wrap">
		<p>
			Fairflow Systems Design Ltd &nbsp;&middot;&nbsp;
			Company number 08299700 &nbsp;&middot;&nbsp;
			<a href="mailto:matthew@fairflow.co.uk">matthew@fairflow.co.uk</a>
		</p>
		<?php if ( is_active_sidebar( 'footer-1' ) ) : ?>
		<div class="footer-widgets">
			<?php dynamic_sidebar( 'footer-1' ); ?>
		</div>
		<?php endif; ?>
	</div>
</footer>

<?php wp_footer(); ?>
</body>
</html>
