
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <link rel="stylesheet" href="{{asset('assets/admin/css/bootstrap.min.css')}}">
    <link rel="stylesheet" href="{{asset('assets/admin/css/fontawesome-all.min.css')}}">
    <link rel="stylesheet" href="{{asset('assets/user/css/fontawesome.min.css')}}">

    <!-- fontawesome css -->
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.9.0/css/all.css" integrity="sha384-i1LQnF23gykqWXg6jxC2ZbCbUMxyw5gLZY6UiUS98LYV5unm8GWmfkIS6jqJfb4E" crossorigin="anonymous">
    
    <link rel="stylesheet" href="{{asset('assets/admin/css/datatables.min.css')}}">
    <link rel="stylesheet" href="{{asset('assets/admin/css/fullcalendar.min.css')}}">
    <link rel="stylesheet" href="{{asset('assets/admin/css/bootadmin.min.css')}}">

    {{--Bootstrap Toggle--}}
    <link href="{{asset('assets/admin/css/bootstrap-toggle.min.css')}}" rel="stylesheet">
    <script src="{{asset('assets/admin/js/jquery-2.1.1.min.js')}}"></script>
    <script src="{{asset('assets/admin/js/bootstrap-toggle.min.js')}}"></script>

    {{--customs css--}}
    <link rel="stylesheet" href="{{asset('assets/admin/css/customs.css')}}">

    {{--toastr--}}
    <link href="{{asset('assets/toastr/toastr.min.css')}}" rel="stylesheet"/>
    <script src="{{asset('assets/toastr/toastr.min.js')}}"></script>

    <!--Icofont CSS-->
    <link rel="stylesheet" type="text/css" href="{{asset('assets/user/css/icofont.css')}}">

    <!-- morris css -->
    <link rel="stylesheet" href="{{asset('assets/admin/css/morris.css')}}">
    <script src=" {{asset('assets/admin/js/raphael-min.js')}}"></script>
    <script src=" {{asset('assets/admin/js/morris.min.js')}}"></script>

    <title>@yield('title')</title>
    @yield('heads')
</head>
<body class="bg-light">

{{--nav--}}
@include('manager.includes.nav')

<div class="d-flex">
    {{--sidebar--}}
    @include('manager.includes.sidebar')


    <div class="content p-4">

        {{--toastr--}}
        <script>
            @if(Session()->has('success'))

toastr.success("{{Session('success')}}")
            @endif

            @if(Session()->has('warning'))

toastr.warning("{{Session('warning')}}")
            @endif

          @if(Session()->has('errors'))
            @foreach($errors->all() as $error)
toastr.error("{{$error}}")
            @endforeach
            @endif
        </script>

        @yield('body')
    </div>
</div>

<script src=" {{asset('assets/admin/js/jquery-2.1.1.min.js')}}"></script>
<script src=" {{asset('assets/admin/js/bootstrap.bundle.min.js')}}"></script>
<script src=" {{asset('assets/admin/js/datatables.min.js')}}"></script>
<script src=" {{asset('assets/admin/js/moment.min.js')}}"></script>
<script src=" {{asset('assets/admin/js/fullcalendar.min.js')}}"></script>
<script src=" {{asset('assets/admin/js/bootadmin.min.js')}}"></script>

<script>
    window.Laravel = @php echo  json_encode([
        'csrfToken' => csrf_token(),
    ]) ; @endphp;
</script>
@yield('scripts')

</body>
</html>