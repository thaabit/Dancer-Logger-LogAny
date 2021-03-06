package Dancer::Logger::LogAny;
# ABSTRACT: Use Log::Any to control logging from your Dancer app

use strict;
use warnings;
use Dancer::Config 'setting';
use Log::Any;
use parent qw{Dancer::Logger::Abstract};

my $_logger;

=head1 DESCRIPTION

This module implements a logger engine that send log messages through
C<Log::Any>.

=head1 CONFIGURATION

=head2 Using Dancer::Logger::LogAny

The setting B<logger> should be set to C<LogAny> in order to use this
logger engine in a Dancer application.

=head2 Setting the category

If you provide C<Dancer::Logger::LogAny> with a C<category>, it will
use that for any logging done through the C<Dancer> logging functions,
like so:

    LogAny:
      category: Wombats

=head2 Setting the logger

C<Dancer::Logger::LogAny> lets you do very simple configuration of the
logger from your config files---simply encode the parameters for
C<Log::Any::Adapter-&gt;set> as an array named C<logger>, like so:

    LogAny:
      logger:
        - Syslog
        - name
        - 'my-web-app'

For more sophisticated usage, you may wish to use
C<Log::Any::Adapter-&gt;set> directly.

=head1 METHODS

=head2 init()

The init method is called by Dancer when creating the logger engine
with this class. It will initiate a Log::Any logger using the possibly
supplied category.

=head1 DEPENDENCY

This module depends on L<Log::Any>.

=cut

sub init {
    my ($self) = @_;
    my $settings = setting ('LogAny') || {};
    if ($settings->{logger}) {
        require Log::Any::Adapter;
        Log::Any::Adapter->set (@{$settings->{logger}});
    }
    my %param = exists $settings->{category}
        ? (category => $settings->{category})
        : ();
    $_logger = Log::Any->get_logger (%param);
}

sub _log {
    my ($self, $level, $message) = @_;
    $level = 'info' if $level eq 'core';
    $_logger->$level ($message);
}

1;
