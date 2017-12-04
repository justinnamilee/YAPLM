# YAPLM
Yet Another Perl Logging Module is a dead-simple logging module based on the TIE::SCALAR Perl definition.

-- --

# Install
* install the Tie::Scalar folder into your namespace
* use the tie() call to bind the module to a scalar (E.G. tie(my $log, 'Tie::Scalar::Log'))
* assign values to the tie'd scalar to print to the log (E.G. $log = 'log this to file')
* supports array and hash data logging directly
