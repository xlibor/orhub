
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.
-- @return  void

function _M:up(schema)

    -- Create table for storing roles
    schema:create('roles', function(table)
        table:increments('id')
        table:string('name'):unique()
        table:string('display_name'):nullable()
        table:string('description'):nullable()
        table:timestamps()
    end)
    -- Create table for associating roles to users (Many-to-Many)
    schema:create('role_user', function(table)
        table:integer('user_id'):unsigned()
        table:integer('role_id'):unsigned()
        table:foreign('user_id'):references('id'):on('users'):onUpdate('cascade'):onDelete('cascade')
        table:foreign('role_id'):references('id'):on('roles'):onUpdate('cascade'):onDelete('cascade')
        table:primary({'user_id', 'role_id'})
    end)
    -- Create table for storing permissions
    schema:create('permissions', function(table)
        table:increments('id')
        table:string('name'):unique()
        table:string('display_name'):nullable()
        table:string('description'):nullable()
        table:timestamps()
    end)
    -- Create table for associating permissions to roles (Many-to-Many)
    schema:create('permission_role', function(table)
        table:integer('permission_id'):unsigned()
        table:integer('role_id'):unsigned()
        table:foreign('permission_id'):references('id'):on('permissions'):onUpdate('cascade'):onDelete('cascade')
        table:foreign('role_id'):references('id'):on('roles'):onUpdate('cascade'):onDelete('cascade')
        table:primary({'permission_id', 'role_id'})
    end)
end

-- Reverse the migrations.
-- @return  void

function _M:down(schema)

    schema:drop('permission_role')
    schema:drop('permissions')
    schema:drop('role_user')
    schema:drop('roles')
end

return _M

