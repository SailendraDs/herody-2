<div class="sidebar sidebar-dark bg-dark">
    <ul class="list-unstyled">
        <li class="active"><a href="{{route('admin.dashboard')}}"><i class="fa fa-home"></i> Dashboard</a></li>

        <li>
            <a href="#Jobs" data-toggle="collapse">
                <i class="fas fa-briefcase"></i> Works
            </a>
            <ul id="Jobs" class="list-unstyled collapse">

                <li><a href="{{route('admin.work.pending')}}"><i class="far fa-circle"></i> Pending Works</a></li>
                <li><a href="{{route('admin.work.all')}}"><i class="far fa-circle"></i> All Works</a></li>
                <li><a href="{{route('admin.work.export')}}"><i class="far fa-circle"></i> Export all to excel</a></li>

            </ul>
        </li>
        <li id="managers"><a href="{{route('admin.managers')}}"><i class="far fa-user"></i> Managers</a></li>
        <li id="employers"><a href="{{route('admin.employers')}}"><i class="fa fa-building"></i> Employers</a></li>
        <li id="chats"><a href="{{route('admin.chats')}}"><i class="fa fa-comments"></i> Chats</a></li>
        <li id="supports"><a href="{{route('admin.supports')}}"><i class="fa fa-headset"></i> Supports</a></li>

        <li>
            <a href="#Withdraw" data-toggle="collapse">
                <i class="fa fa-fw fa-arrow-down"></i> Withdraw System
            </a>
            <ul id="Withdraw" class="list-unstyled collapse">

                <li><a href="{{route('admin.withdrawals.pending')}}"><i class="far fa-circle"></i> Withdrawal Requests</a></li>
                <li><a href="{{route('admin.withdrawals.approved')}}"><i class="far fa-circle"></i> Approved Withdrawals</a></li>
                <li><a href="{{route('admin.withdraw.export')}}"><i class="far fa-circle"></i> Export all to excel</a></li>

            </ul>
        </li>

        <li>
            <a href="#memberSetting" data-toggle="collapse">
                <i class="fa fa-fw fa-users"></i> Member Settings
            </a>
            <ul id="memberSetting" class="list-unstyled collapse">

                <li><a href="{{route('admin.member.all')}}"><i class="far fa-circle"></i> All Member</a></li>

            </ul>
        </li>

        <li>
            <a href="#joinTeam" data-toggle="collapse">
                <i class="fa fa-fw fa-user-friends"></i> Join Team
            </a>
            <ul id="joinTeam" class="list-unstyled collapse">

                <li><a href="{{route('admin.join-team.page')}}"><i class="far fa-circle"></i> Page Settings</a></li>
                <li><a href="{{route('admin.join-team.categories')}}"><i class="far fa-circle"></i> Categories</a></li>
                <li><a href="{{route('admin.join-team.forms')}}"><i class="far fa-circle"></i> Forms</a></li>

            </ul>
        </li>

        <li>
            <a href="#customProject" data-toggle="collapse">
                <i class="fa fa-fw fa-project-diagram"></i> Custom Project
            </a>
            <ul id="customProject" class="list-unstyled collapse">

                <li><a href="{{route('admin.custom-project.page')}}"><i class="far fa-circle"></i> Page Settings</a></li>
                <li><a href="{{route('admin.custom-project.categories')}}"><i class="far fa-circle"></i> Categories</a></li>
                <li><a href="{{route('admin.custom-project.forms')}}"><i class="far fa-circle"></i> Forms</a></li>

            </ul>
        </li>

    </ul>

</div>

