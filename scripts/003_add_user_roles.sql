-- =============================================================================
-- MIGRATION: Add User Roles Table
-- TICKET: DB-003
-- DESCRIPTION: Implement role-based access control
-- =============================================================================

CREATE TABLE IF NOT EXISTS ROLES (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    NAME NVARCHAR(100) NOT NULL UNIQUE,
    DESCRIPTION NVARCHAR(500),
    CREATED_AT DATETIME DEFAULT GETUTCDATE()
);

CREATE TABLE IF NOT EXISTS USER_ROLES (
    USER_ID INT NOT NULL,
    ROLE_ID INT NOT NULL,
    ASSIGNED_AT DATETIME DEFAULT GETUTCDATE(),
    PRIMARY KEY (USER_ID, ROLE_ID),
    FOREIGN KEY (USER_ID) REFERENCES USERS(ID) ON DELETE CASCADE,
    FOREIGN KEY (ROLE_ID) REFERENCES ROLES(ID) ON DELETE CASCADE
);

CREATE INDEX idx_user_roles_user ON USER_ROLES(USER_ID);
CREATE INDEX idx_user_roles_role ON USER_ROLES(ROLE_ID);

-- Insert default roles
IF NOT EXISTS (SELECT 1 FROM ROLES WHERE NAME = 'Administrator')
    INSERT INTO ROLES (NAME, DESCRIPTION) VALUES 
        ('Administrator', 'Full system access'),
        ('Manager', 'Management access'),
        ('User', 'Standard user access');

PRINT 'Role-based access control tables created successfully';
