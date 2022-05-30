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

    <!-- Bootstrap core CSS -->
    <link rel="stylesheet" href="{{asset("assets/main/css/bootstrap.min.css")}}" type="text/css">

    <!--Material Icon -->
    <link rel="stylesheet" type="text/css" href="{{asset("assets/main/css/materialdesignicons.min.css")}}" />

    <link rel="stylesheet" type="text/css" href="{{asset("assets/main/css/fontawesome.css")}}" />

    <!-- selectize css -->
    <link rel="stylesheet" type="text/css" href="{{asset("assets/main/css/selectize.css")}}" />

    <!--Slider-->
    <link rel="stylesheet" href="{{asset("assets/main/css/owl.carousel.css")}}" />
    <link rel="stylesheet" href="{{asset("assets/main/css/owl.theme.css")}}" />
    <link rel="stylesheet" href="{{asset("assets/main/css/owl.transitions.css")}}" />

    <!-- Custom  Css -->
    <link rel="stylesheet" type="text/css" href="{{asset("assets/main/css/style.css")}}" />
    <script>
        window.__INITIAL_STATE__ = "{{url('/')}}";
    </script>
    <!-- fontawesome css -->
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.9.0/css/all.css" integrity="sha384-i1LQnF23gykqWXg6jxC2ZbCbUMxyw5gLZY6UiUS98LYV5unm8GWmfkIS6jqJfb4E" crossorigin="anonymous">
    <!-- Toastr -->
    <link href="{{asset('assets/toastr/toastr.min.css')}}" rel="stylesheet"/>
    @if(Auth::check() or Auth::guard('employer')->check() or Auth::guard('manager')->check() or Auth::check())
        <link rel="stylesheet" href="{{asset('assets/user/css/mnav.css')}}" type="text/css">
    @endif
    @yield("heads")

</head>
  <body>
    <!-- Loader -->
    <div id="preloader">
        <div id="status">
            <div class="spinner">
                <div class="double-bounce1"></div>
                <div class="double-bounce2"></div>
            </div>
        </div>
    </div>
    <!-- Loader -->
    @include('includes.header')
    <section class="section">
        @yield('content')
    </section>
    @if(!Request::is("user*") and !Request::is("company*") and !Request::is("manager*"))
    @include('includes.footer')
    @endif

    <!-- Back to top -->
    <a href="#" class="back-to-top rounded text-center" id="back-to-top"> 
        <i class="mdi mdi-chevron-up d-block"> </i> 
    </a>
    <!-- Back to top -->

    <!-- javascript -->
    <script src="{{asset("assets/main/js/jquery.min.js")}}"></script>
    <script src="{{asset("assets/main/js/bootstrap.bundle.min.js")}}"></script>
    <script src="{{asset("assets/main/js/jquery.easing.min.js")}}"></script>
    <script src="{{asset("assets/main/js/plugins.js")}}"></script>

    <!-- selectize js -->
    <script src="{{asset("assets/main/js/selectize.min.js")}}"></script>
    <script src="{{asset("assets/main/js/jquery.nice-select.min.js")}}"></script>

    <script src="{{asset("assets/main/js/owl.carousel.min.js")}}"></script>
    <script src="{{asset("assets/main/js/counter.int.js")}}"></script>

    <script src="{{asset("assets/main/js/app.js")}}"></script>
    <script src="{{asset("assets/main/js/home.js")}}"></script>
    <script src="{{asset('assets/toastr/toastr.min.js')}}"></script>
    <script src="{{asset('assets/user/js/mnav.js')}}" type="text/javascript"></script>

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