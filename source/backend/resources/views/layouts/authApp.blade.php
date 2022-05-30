<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>@yield("title")</title>
    <meta name="description" content="" />
    <meta name="keywords" content="" />
    <meta name="author" content="Themesdesign" />

    <link rel="shortcut icon" href="images/favicon.ico">
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <link href="{{asset("assets/main/assets/plugins/morris-chart/morris.css")}}" rel="stylesheet">
    <!-- Theme Css -->
    <link href="{{asset("assets/main/assets/css/bootstrap.min.css")}}" rel="stylesheet">
    <link href="{{asset("assets/main/assets/css/slidebars.min.css")}}" rel="stylesheet">
    <link href="{{asset("assets/main/assets/css/icons.css")}}" rel="stylesheet">
    <link href="{{asset("assets/main/assets/css/menu.css")}}" rel="stylesheet" type="text/css">
    <link href="{{asset("assets/main/assets/css/style.css")}}" rel="stylesheet">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.9.0/css/all.css" integrity="sha384-i1LQnF23gykqWXg6jxC2ZbCbUMxyw5gLZY6UiUS98LYV5unm8GWmfkIS6jqJfb4E" crossorigin="anonymous">
    <script>
        window.__INITIAL_STATE__ = "{{url('/')}}";
    </script>
    <!-- fontawesome css -->
    <!-- Toastr -->
    <link href="{{asset('assets/toastr/toastr.min.css')}}" rel="stylesheet"/>
    @yield("heads")

</head>
  <body class="sticky-header">
      <section>
        @if(Auth::check())
        @include("includes.user-sidebar")
        @elseif(Auth::guard('employer')->check())
        @include("includes.emp-sidebar")
        @elseif(Auth::guard('manager')->check())
        @include("includes.manager-sidebar")
        @endif

        <!-- body content start-->
        <div class="body-content">
            <!-- header section start-->
            @include("includes.authHeader")
            <!-- header section end-->

            <div class="container-fluid">
                @yield('content')
            </div><!--end container-->

            <!--footer section start-->
            <footer class="footer">
                @include('includes.footer')
            </footer>
            <!--footer section end-->
        </div>
        <!--end body content-->
      </section>

    <!-- Back to top -->
    <a href="#" class="back-to-top rounded text-center" id="back-to-top"> 
        <i class="mdi mdi-chevron-up d-block"> </i> 
    </a>
    <!-- Back to top -->

        <!-- jQuery -->
        <script src="{{asset("assets/main/assets/js/jquery-3.2.1.min.js")}}"></script>
        <script src="{{asset("assets/main/assets/js/popper.min.js")}}"></script>
        <script src="{{asset("assets/main/assets/js/bootstrap.min.js")}}"></script>
        <script src="{{asset("assets/main/assets/js/jquery-migrate.js")}}"></script>
        <script src="{{asset("assets/main/assets/js/modernizr.min.js")}}"></script>
        <script src="{{asset("assets/main/assets/js/jquery.slimscroll.min.js")}}"></script>
        <script src="{{asset("assets/main/assets/js/slidebars.min.js")}}"></script>

        <!--plugins js-->
        <script src="{{asset("assets/main/assets/plugins/counter/jquery.counterup.min.js")}}"></script>
        <script src="{{asset("assets/main/assets/plugins/waypoints/jquery.waypoints.min.js")}}"></script>
        <script src="{{asset("assets/main/assets/plugins/sparkline-chart/jquery.sparkline.min.js")}}"></script>
        <script src="{{asset("assets/main/assets/pages/jquery.sparkline.init.js")}}"></script>

        <script src="{{asset("assets/main/assets/plugins/chart-js/Chart.bundle.js")}}"></script>
        <script src="{{asset("assets/main/assets/plugins/morris-chart/raphael-min.js")}}"></script>
        <script src="{{asset("assets/main/assets/plugins/morris-chart/morris.js")}}"></script>
        <script src="{{asset("assets/main/assets/pages/dashboard-init.js")}}"></script>


        <!--app js-->
        <script src="{{asset("assets/main/assets/js/jquery.app.js")}}"></script>
        <script>
            jQuery(document).ready(function($) {
                $('.counter').counterUp({
                delay: 100,
                time: 1200
                });
            });
        </script>
    <script src="{{asset('assets/toastr/toastr.min.js')}}"></script>

    <script>
        @if(Session()->has('success'))
        toastr.success("{{Session('success')}}")
        @endif

        @if(Session()->has('warning'))
        toastr.warning("{{Session('warning')}}")
        @endif

        @if(Session()->has('error'))
        toastr.error("{{Session('error')}}")
        @endif

        @if(count($errors)>0)
            @foreach($errors->all() as $error)
                toastr.error("{{$error}}")
            @endforeach
        @endif
        </script>
  @yield('scripts')
</body>
</html>