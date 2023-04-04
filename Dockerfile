#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["ManagementDNApi/ManagementDNApi.csproj", "ManagementDNApi/"]
COPY ["ManagementBusinessLogicLayer/ManagementBusinessLogicLayer.csproj", "ManagementBusinessLogicLayer/"]
COPY ["ManagementDataLayer/ManagementDataLayer.csproj", "ManagementDataLayer/"]
COPY ["ManagementNurseModels/ManagementNurseModels.csproj", "ManagementNurseModels/"]
RUN dotnet restore "ManagementDNApi/ManagementDNApi.csproj"
COPY . .
WORKDIR "/src/ManagementDNApi"
RUN dotnet build "ManagementDNApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ManagementDNApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ManagementDNApi.dll"]