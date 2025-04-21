"""initial migration

Revision ID: initial
Revises: 
Create Date: 2024-04-01 21:08:00.000000

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = 'initial'
down_revision = None
branch_labels = None
depends_on = None

def upgrade() -> None:
    # Create enum type for user roles
    op.execute("CREATE TYPE userrole AS ENUM ('victim', 'volunteer', 'ngo', 'admin')")

    # Create users table
    op.create_table(
        'users',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('email', sa.String(), nullable=False),
        sa.Column('hashed_password', sa.String(), nullable=False),
        sa.Column('full_name', sa.String(), nullable=False),
        sa.Column('role', postgresql.ENUM('victim', 'volunteer', 'ngo', 'admin', name='userrole'), nullable=False),
        sa.Column('is_active', sa.Boolean(), nullable=False, server_default='true'),
        sa.Column('created_at', sa.DateTime(), nullable=False, server_default=sa.text('now()')),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('email')
    )
    op.create_index(op.f('ix_users_email'), 'users', ['email'], unique=True)
    op.create_index(op.f('ix_users_id'), 'users', ['id'], unique=False)

    # Create volunteer_profiles table
    op.create_table(
        'volunteer_profiles',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('user_id', sa.Integer(), nullable=False),
        sa.Column('skills', sa.String(), nullable=False),
        sa.Column('availability', sa.Boolean(), nullable=False, server_default='true'),
        sa.Column('current_latitude', sa.Float(), nullable=True),
        sa.Column('current_longitude', sa.Float(), nullable=True),
        sa.Column('last_location_update', sa.DateTime(), nullable=True),
        sa.ForeignKeyConstraint(['user_id'], ['users.id'], ),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_volunteer_profiles_id'), 'volunteer_profiles', ['id'], unique=False)

    # Create aid_requests table
    op.create_table(
        'aid_requests',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('requester_id', sa.Integer(), nullable=False),
        sa.Column('type', sa.String(), nullable=False),
        sa.Column('description', sa.String(), nullable=False),
        sa.Column('latitude', sa.Float(), nullable=False),
        sa.Column('longitude', sa.Float(), nullable=False),
        sa.Column('status', sa.String(), nullable=False),
        sa.Column('created_at', sa.DateTime(), nullable=False, server_default=sa.text('now()')),
        sa.Column('assigned_volunteer_id', sa.Integer(), nullable=True),
        sa.ForeignKeyConstraint(['assigned_volunteer_id'], ['volunteer_profiles.id'], ),
        sa.ForeignKeyConstraint(['requester_id'], ['users.id'], ),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_aid_requests_id'), 'aid_requests', ['id'], unique=False)

def downgrade() -> None:
    # Drop tables
    op.drop_index(op.f('ix_aid_requests_id'), table_name='aid_requests')
    op.drop_table('aid_requests')

    op.drop_index(op.f('ix_volunteer_profiles_id'), table_name='volunteer_profiles')
    op.drop_table('volunteer_profiles')

    op.drop_index(op.f('ix_users_id'), table_name='users')
    op.drop_index(op.f('ix_users_email'), table_name='users')
    op.drop_table('users')

    # Drop enum type
    op.execute('DROP TYPE userrole') 