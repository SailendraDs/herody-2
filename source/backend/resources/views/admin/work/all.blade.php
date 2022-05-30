@extends('admin.master')

@section('title', 'Admin | All Works')

@section('body')

    <div class="container-fluid">
        <h2 class="mb-4">Works List</h2>

        <div class="card mb-4">
            <div class="card-header bg-white font-weight-bold">
                Works
            </div>
            <div class="card-body">
                @if(count($works)==0)
                    <h2 class="text-center">@lang('No Data Available')</h2>
                @else
                    <table class="table  table-striped table-bordered">
                        <thead>
                        <tr>
                            <th scope="col">ID</th>
                            <th scope="col">Name</th>
                            <th scope="col">Category</th>
                            <th scope="col">Apply Before</th>
                            <th scope="col">Price</th>
                            <th scope="col">Number of candidates Required</th>
                            <th scope="col">Duration</th>
                        </tr>
                        </thead>
                        <tbody>

                        @foreach($works as $work)
                            <tr>
                                <th scope="row">{{$loop->iteration}}</th>
                                <td>{{$work->name}}</td>
                                <td>{{$work->category}}</td>
                                <td>{{$work->last_apply}}</td>
                                <td>{{$work->price}}</td>
                                <td>{{$work->candidates}}</td>
                                <td>{{$work->duration}}</td>
                            </tr>
                        @endforeach

                        </tbody>
                    </table>
                @endif
                {{$works->links()}}
            </div>
        </div>
    </div>
    
    {{--dropdown active--}}
    <script>
        $('#pending li:nth-child(2)').addClass('active');
        $('#pending').addClass('show');
    </script>
@endsection