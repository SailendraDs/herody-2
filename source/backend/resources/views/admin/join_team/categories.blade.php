@extends('admin.master')

@section('title', 'Admin | Join Team Categories')

@section('body')

    <div class="container-fluid">
        <h2 class="mb-4">Join Team</h2>
            <button class="btn btn-primary mb-2" data-toggle="modal" data-target="#create">Create Category</button>

        <div class="card mb-4">
            <div class="card-header bg-white font-weight-bold">
                Categories
            </div>
            <div class="card-body">
                @if(count($categories)==0)
                    <h2 class="text-center">@lang('No Data Available')</h2>
                @else
                    <table class="table  table-striped table-bordered">
                        <thead>
                        <tr>
                            <th scope="col">ID</th>
                            <th scope="col">Name</th>
                            <th scope="col"></th>
                        </tr>
                        </thead>
                        <tbody>

                        @foreach($categories as $category)
                            <tr>
                                <th scope="row">{{$loop->iteration}}</th>
                                <th scope="row">{{$category->category}}</th>
                                <th scope="row">
                                    <form action="{{route('admin.join-team.categories.delete')}}" method="post">
                                    @csrf
                                        <input type="hidden" name="id" value="{{$category->id}}">
                                        <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                    </form>
                                </th>
                                
                            </tr>
                        @endforeach

                        </tbody>
                    </table>
                @endif
                {{$categories->links()}}
            </div>
        </div>
    </div>
    
    
    <div class="modal fade" id="create" tabindex="-1" role="dialog" aria-labelledby="create">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="myModalLabel">Create a new category</h4>
                </div>
                <form action="{{route('admin.join-team.categories')}}" method="post">
                    @csrf
                    <div class="modal-body">
                        <div class="input-group mb-2">
                            <input type="text" placeholder="Enter Category Name" name="name" class="form-control">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success">Create</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    {{--dropdown active--}}
    <script>
        $('#joinTeam li:nth-child(2)').addClass('active');
        $('#joinTeam').addClass('show');
    </script>
@endsection