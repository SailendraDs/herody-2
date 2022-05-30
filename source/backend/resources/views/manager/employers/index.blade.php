@extends('manager.master')

@section('title', 'Manager | All Employers')

@section('body')

    <div class="container-fluid">
        <h2 class="mb-4">Employers List</h2>

        <div class="card mb-4">
            <div class="card-header bg-white font-weight-bold">
                Employers
            </div>
            <div class="card-body">
                @if(count($employers)==0)
                    <h2 class="text-center">@lang('No Data Available')</h2>
                @else
                    <table class="table  table-striped table-bordered">
                        <thead>
                        <tr>
                            <th scope="col">ID</th>
                            <th scope="col">Name</th>
                            <th scope="col">Company Name</th>
                            <th scope="col">Email</th>
                            <th scope="col"></th>
                        </tr>
                        </thead>
                        <tbody>

                        @foreach($employers as $employer)
                            <tr>
                                <th scope="row">{{$loop->iteration}}</th>
                                <th scope="row">{{$employer->name}}</th>
                                <th scope="row">{{$employer->cname}}</th>
                                <th scope="row">{{$employer->email}}</th>
                                <th scope="row">
                                    <form action="{{route('manager.employer.login')}}" method="post">
                                    @csrf
                                        <input type="hidden" name="id" value="{{$employer->id}}">
                                        <button type="submit" class="btn btn-danger btn-sm">Login</button>
                                    </form>
                                </th>
                                
                            </tr>
                        @endforeach

                        </tbody>
                    </table>
                @endif
                {{$employers->links()}}
            </div>
        </div>
    </div>
    {{--dropdown active--}}
    <script>
        $('#employers').addClass('active');
    </script>
@endsection