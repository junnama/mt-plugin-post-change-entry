package PostChangeEntryCallback::Callbacks;

use strict;

sub _cb_cms_post_save_page {
    my $cb = shift;
    my ( $app, $obj, $original ) = @_;
    my $do;
    if ( $cb->name =~ /^cms_post_delete/ ) {
         $do = 1;  
    } else {
        if ( defined $original ) {
            if ( $original->status == 2 || $obj->status == 2 ) {
                $do = 1;
            }
        } else {
            if ( $obj->status == 2 ) {
                $do = 1;
            }
        }
        if ( $do ) {
            my $changed = $obj->{ changed_revisioned_cols };
            if ( ( ref $changed ) ne 'ARRAY' ) {
                $do = undef;
            }
        }
    }
    if ( $do ) {
        MT->run_callbacks( 'cms_post_change.' . $obj->class, @_ );
    }
    return 1;
}

1;