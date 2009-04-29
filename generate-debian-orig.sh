
tarball=openjdk-6-src-b16-13_apr_2009.tar.gz
version=6b16~pre1
hotspot=hotspot-20081220.tar.gz
cacaotb=cacao-0.99.4.tar.bz2
base=openjdk-6
#base=cacao-oj6
pkgdir=$base-$version
origtar=${base}_${version}.orig.tar.gz

icedtea_checkout=../icedtea6
debian_checkout=openjdk6

if [ -d $pkgdir ]; then
    echo directory $pkgdir already exists
    exit 1
fi

if [ -d $pkgdir.orig ]; then
    echo directory $pkgdir.orig already exists
    exit 1
fi

if [ -f $origtar ]; then
    tar xf $origtar
    if [ -d $pkgdir.orig ]; then
	mv $pkgdir.orig $pkgdir
    fi
    tar -c -f - -C $icedtea_checkout . | tar -x -f - -C $pkgdir
    cp -a $debian_checkout $pkgdir/debian
else
    rm -rf $pkgdir.orig
    mkdir -p $pkgdir.orig
    case "$base" in
      openjdk*)
	cp -p $hotspot $pkgdir.orig/
	cp -p $tarball $pkgdir.orig/
	if [ $(lsb_release -is) = Ubuntu ]; then
	    cp -p $cacaotb $pkgdir.orig/
	fi
	;;
      cacao*)
	if [ -f $cacaotb ]; then
	    : # don't include the cacao tarball anymore
	    #cp -p $cacaotb $pkgdir.orig/
	fi
    esac
    tar -c -f - -C $icedtea_checkout . | tar -x -f - -C $pkgdir.orig
    (
	cd $pkgdir.orig
	sh autogen.sh
	rm -rf autom4te.cache
    )
    cp -a $pkgdir.orig $pkgdir
    rm -rf $pkgdir.orig/.hg
    cp -a $debian_checkout $pkgdir/debian
fi
