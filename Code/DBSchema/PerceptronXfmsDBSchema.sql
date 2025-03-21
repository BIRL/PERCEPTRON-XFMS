SELECT name FROM sys.databases WHERE name = 'PerceptronXfmsDatabase';

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'PerceptronXfmsDatabase')
BEGIN
    CREATE DATABASE PerceptronXfmsDatabase;
END
GO

USE [PerceptronXfmsDatabase]
GO
/****** Object:  Table [dbo].[ResultsVisualize]    Script Date: 12/19/2024 11:09:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResultsVisualize](
	[QueryID] [nchar](50) NOT NULL,
	[FastaFileInfo] [nvarchar](max) NULL,
	[PeptideInfo] [nvarchar](max) NULL,
	[PfSasaTabXlsFile] [nvarchar](max) NULL,
	[BridgeResultsFile] [nvarchar](max) NULL,
	[SasaMainImageFile] [nvarchar](max) NULL,
	[PfModifiedPdb] [nvarchar](max) NULL,
	[CentralityModifiedPdb] [nvarchar](max) NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FrustratometerResultFiles] [nvarchar](max) NULL,
 CONSTRAINT [PK_SearchResultsFile] PRIMARY KEY CLUSTERED 
(
	[QueryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SearchResultsFile]    Script Date: 12/19/2024 11:09:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SearchResultsFile](
	[QueryID] [nvarchar](50) NOT NULL,
	[ZipResultFile] [nvarchar](max) NULL,
	[CreationTime] [datetime2](7) NULL,
 CONSTRAINT [PK_SearchResultsFile_1] PRIMARY KEY CLUSTERED 
(
	[QueryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SearchXfmsQuery]    Script Date: 12/19/2024 11:09:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SearchXfmsQuery](
	[QueryID] [nvarchar](50) NOT NULL,
	[UserID] [nvarchar](50) NOT NULL,
	[Progress] [nvarchar](50) NOT NULL,
	[CreationTime] [datetime2](7) NOT NULL,
	[isBridgeEnabled] [nvarchar](10) NOT NULL,
	[isFrustratometerEnabled] [nvarchar](10) NOT NULL,
	[EmailID] [nvarchar](50) NOT NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
	[ExpectedCompletionTime] [datetime2](7) NULL,
	[QueuePosition] [nvarchar](50) NULL,
 CONSTRAINT [PK_SearchQuery] PRIMARY KEY CLUSTERED 
(
	[QueryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
